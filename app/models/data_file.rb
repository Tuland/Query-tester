class DataFile < ActiveRecord::Base
  
    NAME = "02_07_mantic_global.owl"
  
    def self.save(upload)
      name = upload['datafile'].original_filename
      directory = "public/onto"
      # create the file path
      path = File.join(directory, NAME)
      # write the file
      File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    end
end