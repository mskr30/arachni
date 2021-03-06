=begin
                  Arachni
  Copyright (c) 2010-2012 Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>

  This is free software; you can copy and distribute and modify
  this program under the term of the GPL v2.0 License
  (See LICENSE file for details)

=end

module Arachni

#
# The namespace under which all modules exist
#
module Reports
end

module Report

#
# Arachni::Report::Manager class
#
# Holds and manages the registry of the reports.
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr> <br/>
# @version: 0.1.1
#
class Manager < Arachni::ComponentManager

    include Arachni::Module::Utilities

    # the extension of the Arachni Framework Report files
    EXTENSION   = '.afr'

    def initialize( opts )
        super( opts.dir['reports'], Arachni::Reports )
        @opts = opts
    end

    #
    # Takes care of report execution
    #
    # @see AuditStore
    #
    # @param  [AuditStore]  audit_store
    #
    def run( audit_store, run_afr = true )
        if run_afr
            # run the default report first
            run_one( 'afr', audit_store.deep_clone )
            delete( 'afr' )
        end

        self.each {
            |name, report|
            exception_jail( false ){
                run_one( name, audit_store.deep_clone )
            }
        }
    end

    def run_one( name, audit_store )
        report = self.[](name).new( audit_store.deep_clone,
            prep_opts( name, self.[](name), @opts.reports[name] ) )

        report.run( )
    end

    def paths
        cpaths = paths = Dir.glob( File.join( "#{@lib}", "*.rb" ) )
        return paths.reject { |path| helper?( path ) }
    end


    def extension
        return EXTENSION
    end

end

end
end
