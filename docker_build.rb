# Usage: ruby docker_build.rb buildpack_ruby

def sh!(*cmd)
  puts "$ #{cmd.join(' ')}"
  system(*cmd)
  raise unless $?.success?
end

def build(image_name)
  image_name = image_name[%r!^[^/]+!] # trim slash
  sh! 'docker', 'build', '-t', "quay.io/actcat/#{image_name}:latest", image_name
end

def main(argv)
  argv.each do |image_name|
    build(image_name)
  end
end

main(ARGV)
