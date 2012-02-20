module Tango
  module Contexts
    class User
      attr_reader :username

      def initialize(username)
        @username = username
      end

      def enter
        @uid, @gid = Process.euid, Process.egid
        Process::Sys.seteuid(0) if @uid != 0
        info = Etc.getpwnam(@username)
        Process::Sys.setegid(info.gid)
        Process::Sys.seteuid(info.uid)
      end

      def leave
        Process::Sys.seteuid(@uid)
        Process::Sys.setegid(@gid)
      end

    end
  end
end
