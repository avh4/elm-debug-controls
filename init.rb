#!/usr/bin/env ruby
require 'liquid'
require 'yaml'
require 'fileutils'
require 'find'

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end
def green(text); colorize(text, 32); end
def blue(text); colorize(text, 34); end
def cyan(text); colorize(text, 36); end

# Open the properties file
properties_filename = "properties.yaml"
# Ask the user if the properties are correct
while true
  puts cyan("== #{properties_filename} ==")
  properties_file = File.open properties_filename
  properties_yaml = properties_file.read
  puts properties_yaml
  print blue("Continue with these properties [y,n,e,?]? ")
  $stdout.flush
  reply = gets
  case reply[0]
  when "y"
    break
  when "e"
    system "${EDITOR:=nano} #{properties_filename}"
    system "git commit #{properties_filename} -m 'Updated project properties.'"
  when "?"
    puts red("y - perform project initialization with the current properties")
    puts red("n - quit; do not perform project initializiation")
    puts red("e - edit the properties file")
  when "\n"
  else
    puts "Aborting.  Edit #{properties_filename} to make changes."
    exit
  end
end

# Load the properties
properties = YAML::load(properties_yaml)

# Create Liquid filters
module NameFilter
  def as_path(input)
    input
      .tr('.', '/')
      .tr('-', '')
  end
  def as_java_class(input)
    input
      .gsub(/^[a-z]|[^a-zA-Z0-9]+[a-z]/) { |a| a.upcase }
      .gsub(/[^a-zA-Z0-9]/, '')
  end
end
Liquid::Template.register_filter(NameFilter)

# process the files
ignore = [ ".git" ]
Find.find(".") do |path|
  if ignore.include? File.basename(path) then
    Find.prune
  elsif FileTest.directory?(path)
    next
  else
    name = CGI::unescape(path)
    name = Liquid::Template.parse(name).render properties
    # Make the directory for the file
    dir = File.dirname(name)
    if !File.exists? dir then
      puts "Creating #{dir}"
      FileUtils.mkdir_p dir
    end
    if name =~ /\.liquid$/ then
      name = name.sub(/\.liquid$/, '')
      puts "Processing #{name}..."
      # read the file
      template = File.open(path, "r").read
      # process the file
      rendering = Liquid::Template.parse(template).render properties
      # write the file
      File.open(name, "w") { |f| f.write(rendering) }
      # Delete the template file
      File.delete path
    elsif name == path then
      puts "Copying #{name}..."
      # do nothing - already in place
    else
      puts "Copying #{name}..."
      FileUtils.mv(path, name)
    end
  end
end

puts "Successful.  Cleaning up..."
files_to_delete = [ "init.rb", "README.md" ]
files_to_delete.each do |file|
  puts "Removing #{file}..."
  File.delete file
end

puts "Commiting to git..."
system("git add -A")
system("git commit -m 'Initialize project.'")
system("git clean -df")
puts "Done!  If you need to undo the initialization, `git reset --hard HEAD^`"
