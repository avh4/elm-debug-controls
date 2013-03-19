#!/usr/bin/env ruby
require 'liquid'
require 'yaml'
require 'fileutils'
require 'find'

# Open the properties file
properties_file = File.open "properties.yaml"
properties_yaml = properties_file.read
puts properties_yaml
puts
# Ask the user if the properties are correct
puts "Are these properties correct?"
reply = gets
if reply[0] != "y" then
  puts "Aborting.  Edit properties.yaml to make changes."
  exit
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
      File.open(name, "w").write(rendering)
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

puts "Done!"
