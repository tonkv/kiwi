#pragma once

#ifndef KIWI_ARGUMENTPROCESSOR_HPP
#define KIWI_ARGUMENTPROCESSOR_HPP

#include <list>
#include "kiwi/core/Commons.hpp"


namespace kiwi
{

  /**
   * This class parse the arguments given to the launcher.
   *
   * You just have to instanciate an object of thihs class,
   * giving argc and argv to the one constructor.
   * Then you can get many informations using getters.
   */
  class ArgumentProcessor
  {
    public:
      enum{FALSE=0, INPUT, OUTPUT, GENERAL, PROCESS, NODE, SERVER, REMOTE};

      /**
       * Constructor.
       */
      ArgumentProcessor(int argc, char** argv);


      /**
       * Returns the name of the called filter.
       */
      kiwi::string filterName() {return _filterName;}


      /**
       * Returns a list of the arguments following -i .
       */ 
      std::list<kiwi::string> getFilterInputs() {return _inputs;}


      /**
       * Returns a list of the arguments following -o .
       */ 
      std::list<kiwi::string> getFilterOutputs() {return _outputs;}


      /**
       * Returns true if the syntax is not correct.
       */ 
      bool invalid() {return _invalid;}


      /**
       * Returns true if the process command is invoked.
       */ 
      bool processCmd() {return _process;}


      /**
       * Returns true if the remote command is invoked.
       */ 
      bool remoteCmd() {return _remote;}


      /**
       * Returns true if the server command is invoked.
       */ 
      bool serverCmd() {return _server;}


      /**
       * Returns true if the -v command is invoked.
       */ 
      bool verboseCmd() {return _verbose;}


      /**
       * Returns a value different from 0 if the --help command is invoked.
       */ 
      int helpCmd() {return _help;}


      /**
       * Returns a value different from 0 if the --version command is invoked.
       */ 
      int versionCmd() {return _version;}


    private:
      bool _invalid;
      bool _verbose;
      bool _remote;
      bool _process;
      bool _server;
      int _version;
      int _help;
      kiwi::string _filterName;
      std::list<kiwi::string> _inputs;
      std::list<kiwi::string> _outputs;
  };
}// namespace
#endif
