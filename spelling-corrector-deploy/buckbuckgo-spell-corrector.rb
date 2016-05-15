#! /usr/bin/ruby

require 'mysql'

# Set parameters
TRAINING_FILE = "big.txt"
DB_HOST = "localhost"
DB_USER_NAME = "root"
DB_PASSWORD = "dtsdwarak"
DB_DATABASE = "buckbuckgo"
DB_TABLE = "words"

# Read from training file
f = File.open(TRAINING_FILE, "r")
h = Hash.new
f.each_line { |line|
    words = line.split
    words.each { |w|
        w = w.downcase.gsub(/[^a-zA-Z ]/,'').strip
        if h.has_key?(w)
            h[w] = h[w] + 1
        else
            h[w] = 1
        end
    }
}

# Save to database
begin
    con = Mysql.new DB_HOST, DB_USER_NAME, DB_PASSWORD, DB_DATABASE
    
    # Truncate database table
    con.query("DELETE FROM #{DB_TABLE}")
    
    h.each { |elem|
      con.query("INSERT INTO #{DB_TABLE}(word, count) VALUES('#{elem[0]}',#{elem[1]})")
    }
    
    puts "DB Write successful"
      
rescue Mysql::Error => e
    puts e.errno
    puts e.error
    
ensure
    con.close if con
end

