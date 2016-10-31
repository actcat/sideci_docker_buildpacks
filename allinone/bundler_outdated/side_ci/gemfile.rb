require "json"
require "bundler"
require "bundler/lockfile_parser"

module SideCi

  class GemfileLockNotExistsError < StandardError; end

  # Bundler::Dependency(gem情報クラス)をオーバーライド
  class Bundler::Dependency
    # 利用中のバージョン, 最新のバージョン, source_uri, 定義上限バージョン(未実装), バージョン定義, currentとlatestのchangelogs
    attr_accessor :current_version, :latest_version, :source, :source_uri, :locked, :changelogs, :spec, :active_specs
  end

  class Gemfile

    RUBYGEMS_GEMS_URL = "http://rubygems.org/gems/"

    attr_accessor :gemfile_dir_path, :gemfile_lock_path, :gemfile_lock_content
    attr_accessor :gemfile, :sources, :gems, :specs, :current_dependencies, :gemfile_specs, :dependency_specs, :outdated_gems
    attr_accessor :options


    # SideCi::Gemfile コンストラクタ
    # @param [gemfile_dir_path] Gemfile.lock格納ディレクトリを指定する
    # @return [SideCi::Gemfile]
    def initialize(gemfile_dir_path)
      @gemfile_dir_path = File::expand_path(gemfile_dir_path)
      @gemfile_lock_path = File::expand_path(File.join(@gemfile_dir_path, "Gemfile.lock"))
      @options = {}
      @gem_outdated_count = 0
    end

    # Gemfile.lockの解析
    # @return [SideCi::Gemfile] Gemfile.lockの解析結果を格納したSideCi::Gemfile
    def analysis!
      raise GemfileLockNotExistsError unless File.exist?(@gemfile_lock_path)
      set_gemfile_lock_content(@gemfile_lock_path)

      if parse_gemfile_lock_content?(@gemfile_lock_content)
        puts "------------------Gemfile.lock------------------"
        puts "Gemfile.lock >> dependencies: #{@gems.count}, specs: #{@specs.count}, sources: #{@sources.count}"
        puts "current_specs.count, #{@specs.count}, gemfile_specs.count: #{@gemfile_specs.count}, dependency_specs.count: #{@dependency_specs.count}"

        unless analysis_gemfile_lock?
          puts "Your bundle is up to date!"
        end
      end

      return self
    end

    # Gemfile.lockの解析結果をファイルに出力する
    # @param [output_path] 出力先ファイルパスを指定
    def write_analysis_data(output_path)
      outputs = []
      outdated_status = {}

      # status
      @outdated_gems.each do |outdated_gem|
        outdated_status[outdated_gem.name] = true
      end

      # output
      @gems.each do |gem|
        output = {}
        output[:package] = gem.name
        output[:package_url] = gem.source_uri
        output[:locked] = gem.current_version
        output[:latest] = gem.latest_version
        output[:requirement] = gem.requirement
        output[:status] = outdated_status[gem.name] ? "outdated" : "latest"
        outputs.push output
      end

      # File
      puts "Output json: #{output_path}"
      File.write(output_path, outputs.to_json)
    end

    protected

    # Gemfile.lockファイルの内容をインスタンス変数に格納
    # @param [gemfile_lock_path] Gemfile.lockファイルパス
    def set_gemfile_lock_content(gemfile_lock_path)
      @gemfile_lock_content = File.read(gemfile_lock_path)
    end

    # Gemfile.lockの内容をインスタンス変数にパース
    # @param [gemfile_lock_content] Gemfile.lockファイルコンテンツ
    def parse_gemfile_lock_content?(gemfile_lock_content)
      # Gemfile.lockの内容を取得していない場合はパースしない
      return false if gemfile_lock_content.nil? || gemfile_lock_content.empty?

      lock_file_parser = Bundler::LockfileParser.new(gemfile_lock_content)

      # Gemfile, Gemfile.lockに記載されているgems
      @gems = lock_file_parser.dependencies
      # 依存関係のあるGems
      @specs = lock_file_parser.specs
      # ソースコードからインストールするタイプのGems
      @sources = lock_file_parser.sources

      # Gem情報を格納
      @current_dependencies = {}
      gems.each do |dep|
        @current_dependencies[dep.name] = dep
      end
      @gemfile_specs, @dependency_specs = @specs.partition do |spec|
        # 依存関係のGem情報を格納
        unless @current_dependencies.has_key?(spec.name)
          #@current_dependencies[spec.name] = Bundler::Dependency.new(spec.name, spec.version)
        end
      end

      return true
    end

    # パースしたGemfile.lockの内容を解析
    # @return [true] 新しいバージョンが存在する
    # @return [false] 新しいバージョンが存在しない
    def analysis_gemfile_lock?
      gems_with_specs = []
      outdated_gems = []
      out_count = 0

      definition = Bundler.definition(gems: @gems, sources: @sources)
      definition.resolve_remotely!

      [@gemfile_specs.sort_by(&:name), @dependency_specs.sort_by(&:name)].flatten.each do |current_spec|
        dependency = @current_dependencies[current_spec.name]

        # options[:strict]が有効だった場合、Gemfileの定義に従って(定義の範囲内で)検索される
        # メジャーアップデートを許可しない書き方などをしていた場合にはメジャーアップデートが無視される
        active_specs = nil
        if options[:strict]
          active_spec =  definition.specs.detect { |spec| spec.name == current_spec.name }
        else
          active_spec = definition.index[current_spec.name].sort_by { |b| b.version }
          if !current_spec.version.prerelease? && !options[:pre] && active_spec.size > 1
            active_spec = active_spec.delete_if { |b| b.respond_to?(:version) && b.version.prerelease? }
          end
          active_specs = active_spec
          active_spec = active_spec.last
        end

        dependency.current_version = dependency.latest_version = current_spec.version if !dependency.nil?
        if !dependency.nil?
          active_spec = current_spec if active_spec.nil?

          dependency.latest_version = active_spec.version
          dependency.active_specs = active_specs
          dependency.source = active_spec.source

          case active_spec.source
          when Bundler::Source::Rubygems
            dependency.source_uri = "#{RUBYGEMS_GEMS_URL}#{active_spec.name}"
          when Bundler::Source::Git
            dependency.source_uri = active_spec.source.uri ? active_spec.source.uri.to_s : nil
          when Bundler::Source::Path
            dependency.source_uri = active_spec.source.path ? active_spec.source.path.to_s : nil
          else
            dependency.source_uri = nil
          end
        end

        gems_with_specs << dependency if !dependency.nil?

        next if active_spec.nil?

        gem_outdated = Gem::Version.new(active_spec.version) > Gem::Version.new(current_spec.version)
        if gem_outdated
          # より新しいバージョンがある
          spec_version    = "#{active_spec.version}"
          current_version = "#{current_spec.version}"
          dependency_version = "Gemfile specifies \"#{dependency.requirement}\"" if dependency && dependency.specific?
          puts "* #{active_spec.name} (#{spec_version} > #{current_version}) #{dependency_version}".rstrip
          outdated_gems << dependency if dependency && dependency.specific?
          # NOTE: 下記のメソッドは内容が入っている事が多い
          #[:name, :version, :source, :source_uri, :date].each {|m| puts("#{m}: #{active_spec.send m}"); puts ""}
          out_count += 1
        end
      end
      @outdated_gems = outdated_gems
      @gems = gems_with_specs

      if out_count.zero?
        return false
      else
        return true
      end
    end

  end

end
