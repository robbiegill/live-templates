require 'formatters/ruby_mine'

class Generator
  def self.dump_all!
    Dir['templates/*.yml'].each do |path|
      name = File.basename(path, '.yml')
      File.open(File.join('out', "#{name}.xml"), 'w') do |f|
        f.puts Formatters::RubyMine.dump!(File.new(path))
      end
    end
  end
end
