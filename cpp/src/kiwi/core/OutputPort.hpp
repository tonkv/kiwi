#pragma once
#ifndef KIWI_CORE_OUTPUTPORT_HPP
#define KIWI_CORE_OUTPUTPORT_HPP

#include <vector>
#include "kiwi/core/Connect.hpp"
#include "kiwi/core/Commons.hpp"

namespace kiwi{
namespace core{

class Node;
class Data;
class DataTypeInfo;
class InputPort;
class DataStrategy;

/**
 * Ouput port of a kiwi::core::Node.
 */ 
class OutputPort
{
friend bool kiwi::core::protocol::Connect(OutputPort&,InputPort&);
friend bool kiwi::core::protocol::Disconnect(OutputPort&,InputPort&);
public:
    typedef std::vector<InputPort*> ConnectionArray;

    //OutputPort(){}
    /**
     * Constructor.
     */ 
    OutputPort(Node* n, DataStrategy* datastrategy, DataAccessFlags flags = READ|WRITE)
    :_node(n), _dataStrategy(datastrategy), _accessFlags(flags)
    {
        
    }

    /**
     * Returns reference to a vector containing this port's connected input ports. 
     */ 
    const ConnectionArray& connections() const
    {
        return _connections;
    }

    /**
     * Returns a prointer to the nth connected input port.
     *
     * No range check is performed.
     */ 
    InputPort* connection(int n) const
    {
        return _connections[n];
    }

    /**
     * Returns a pointer to this port's node.
     */ 
    Node* node() const
    {
        return _node;
    }

    /**
     * Returns a pointer to the data of this output port.
     */ 
    Data* data() const;

    /**
     * Returns a pointer to this ports data type info object.
     */ 
    const DataTypeInfo* dataType() const;

    /**
     * returns this port's access flags.
     *
     * the possible flags can be a combination of:
     * READ, WRITE, SIGNAL, SEMANTIC, and eventual user defined flags.
     */ 
    DataAccessFlags accessFlags() const
    {
        return _accessFlags;
    }

    /**
     * Connects to an input port if compatible.
     *
     * @return true if the connection suceeded. 
     */ 
    bool connect( InputPort& port );

    /**
     * Disconnect from a specific input port.
     *
     * @return true if disconnection succeeded, false if this port is not connected
     * to the specified input port.
     */ 
    bool disconnect( InputPort& port );

    /**
     * Disconnect this port from all the inputs connected to it.
     */ 
    bool disconnectAll();

    /**
     * Returns true if this port is compatible with a given input port.
     *
     * This check is performed before every connection.
     */ 
    bool isCompatible(const InputPort& port) const;
    
    /**
     * Returns true if this port has a special data allocation strategy.
     */ 
    bool hasDataStrategy() const
    {
        return _dataStrategy != 0;
    }

    /**
     * Returns true if this port has at least on connection.
     */ 
    bool isConnected() const
    {
    	return _connections.size() != 0;
    }

    /**
     * Returns true if this port is connected to a given input port.
     */ 
    bool isConnectedTo( const InputPort& port )
    {
    	for(int i = 0; i < _connections.size(); ++i)
    		if( &port == _connections[i] )
    			return true;
    	return false;
    }


protected://methods
    int _indexOf(const InputPort& port)
    {
    	for(int i = 0; i < _connections.size(); ++i)
    		if(_connections[i] == &port)
    			return i;
    	return -1;
    }
protected://variables
    Node* _node;
    ConnectionArray _connections;
    DataAccessFlags _accessFlags;
    DataStrategy* _dataStrategy;

};

} //namespace
} //namespace


#endif

