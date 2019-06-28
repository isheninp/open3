# bundle exec rails t:sys

require 'open3'

namespace :t do
  
  task :sys => :environment do |t, args|

  cmd = "ls / && for ((i = 0; i < 23; i++)) do sleep 1; echo $i; done"
  
  data = {:out => [], :err => []}

    Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
      { :out => stdout, :err => stderr }.each do |key, stream|
        Thread.new do
          until (raw_line = stream.gets).nil? do
            parsed_line = Hash[:timestamp => Time.now, :line => "#{raw_line}"]
            data[key].push parsed_line
            puts "#{key}: #{parsed_line}"
          end
        end
      end
      thread.join # don't exit until the external process is done
    end

  end
end