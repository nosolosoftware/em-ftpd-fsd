module FilesHelper
  def ensure_file_exist( path )
    ensure_entity( path, :file )
  end

  def ensure_file_does_not_exist( path )
    ensure_entity( path, :file, false )
  end

  def ensure_dir_exist( path )
    ensure_entity( path, :dir )
  end

  def ensure_dir_does_not_exist( path )
    ensure_entity( path, :dir, false )
  end

  def ensure_entity( relative_path, type, existence = true )
    path = FTPRoot + relative_path

    case type
      when :file
        FileUtils.touch( path ) if( existence and not File.exist?( path ) )
        File.delete( path ) if( File.exist?( path ) and not existence )

        File.exist?( path ).should( existence ? be_true : be_false )
      when :dir
        Dir.mkdir( path ) if( existence and not File.directory?( path ) )
        FileUtils.rm_rf( path ) if( File.directory?( path ) and not existence )

        File.directory?( path ).should( existence ? be_true : be_false )
      else
        fail "Object have to be either file or directory"
      end
  end
end
