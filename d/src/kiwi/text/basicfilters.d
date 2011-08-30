module kiwi.text.basicfilters;

import kiwi.text.data;
import kiwi.commons;
import kiwi.core;
import kiwi.data;
import kiwi.dynamic.node;
import kiwi.dynamic.port;
import kiwi.dynamic.compatibility;

import std.string;
import std.array;




// -------------------------------------------------- filter functions

void applyUpperCase(Data[] input, Data[] output )
{
    if (input is null     || output is null)     return;
    if (input.length == 0 || output.length == 0) return;
    
    auto inputData  = cast(PlainTextContainer) input[0];
    auto outputData = cast(PlainTextContainer) output[0];

    if (inputData is null || outputData is null)  return;
    
    outputData.text = toupper(inputData.text);
}

void applyLowerCase(Data[] input, Data[] output )
{
    if (input is null     || output is null)     return;
    if (input.length == 0 || output.length == 0) return;
    
    auto inputData  = cast(PlainTextContainer) input[0];
    auto outputData = cast(PlainTextContainer) output[0];

    if (inputData is null || outputData is null) return;
    
    outputData.text = tolower(inputData.text);
}

void applyReplace(Data[] input, Data[] output )
{
    if (input is null    || output is null)     return;
    if (input.length < 2 || output.length == 0) return;
    
    auto inputData       = cast(PlainTextContainer) input[0];
    auto inputFromPatern = cast(PlainTextContainer) input[1];
    auto inputToPatern   = cast(PlainTextContainer) input[2];
    auto outputData      = cast(PlainTextContainer) output[0];

    if (inputData is null || inputFromPatern is null || inputToPatern is null || outputData is null)
        return;
    
    outputData.text = std.array.replace(inputData.text, inputFromPatern.text, inputToPatern.text );
}





// ------------------------------------------------------- creators


Node NewUpperCaseFilter()
{
    mixin( logFunction!"NewUpperCaseFilter" );
    InputPortInitializer[] inputs   = [];
    OutputPortInitializer[] outputs = [];
    inputs  ~= InputPortInitializer("Input text", new DataTypeCompatibility(PlainTextContainer.Type));
    outputs ~= OutputPortInitializer("Output text", PlainTextContainer.Type);
    return new DynamicNode( inputs, outputs, &applyUpperCase );
}

Node NewLowerCaseFilter()
{
    mixin( logFunction!"NewLowerCaseFilter" );
    InputPortInitializer[] inputs   = [];
    OutputPortInitializer[] outputs = [];
    inputs  ~= InputPortInitializer("Input text", new DataTypeCompatibility(PlainTextContainer.Type));
    outputs ~= OutputPortInitializer("Output text", PlainTextContainer.Type);
    return new DynamicNode( inputs, outputs, &applyLowerCase );
}

Node NewTextReplaceFilter()
{
    mixin( logFunction!"NewTextReplaceFilter" );
    InputPortInitializer[] inputs   = [];
    OutputPortInitializer[] outputs = [];
    inputs  ~= InputPortInitializer("Input text", new DataTypeCompatibility(PlainTextContainer.Type));
    inputs  ~= InputPortInitializer("From",       new DataTypeCompatibility(PlainTextContainer.Type));
    inputs  ~= InputPortInitializer("To",         new DataTypeCompatibility(PlainTextContainer.Type));
    outputs ~= OutputPortInitializer("Output text", PlainTextContainer.Type);
    return new DynamicNode( inputs, outputs, &applyReplace );
}





//              #######   #####    ####   #####    ####
//                 #      #       #         #     #    
//                 #      ###      ###      #      ### 
//                 #      #           #     #         #
//                 #      #####   ####      #     #### 



unittest{

    mixin(logTest!" kiwi.text.basicfilters");

    // take "<1> <2>!" as input, replace "<1>" by "Hello" and "<2>" by "Word", 
    // then turn it to upper case. 
    //
    // "<1> <2>!" >> |         |
    //      "<1>" >> | replace |
    //    "Hello" >> |         | >> |         |
    //                     "<2>" >> | replace | 
    //                 "<World>" >> |         | >> | upperCase | >> output
    //


    auto upperCaseFilter = NewUpperCaseFilter(); 
    auto replaceFilter1  = NewTextReplaceFilter(); 
    auto replaceFilter2  = NewTextReplaceFilter(); 
    auto inputPhrase     = NewContainerNode( new PlainTextContainer("<1> <2>!") );
    auto inputTextP1     = NewContainerNode( new PlainTextContainer("<1>") );
    auto inputTextP2     = NewContainerNode( new PlainTextContainer("<2>") );
    auto inputTextHello  = NewContainerNode( new PlainTextContainer("Hello") );
    auto inputTextWorld  = NewContainerNode( new PlainTextContainer("World") );
    
    // Check references
    assert( inputPhrase.output() !is null );
    assert( inputPhrase.output().data !is null );

    assert( upperCaseFilter.input()  !is null );
    assert( upperCaseFilter.output() !is null );
    
    assert( inputPhrase.output().dataType !is null );
    assert( replaceFilter1.output().dataType !is null );

    // connect the nodes
    assert( inputPhrase.output().connect( replaceFilter1.input(0) ) );
    assert( inputTextP1.output().connect( replaceFilter1.input(1) ) );
    assert( inputTextHello.output().connect( replaceFilter1.input(2) ) );
    assert( replaceFilter1.output().connect( replaceFilter2.input(0) ) );
    assert( inputTextP2.output().connect( replaceFilter2.input(1) ) );
    assert( inputTextWorld.output().connect( replaceFilter2.input(2) ) );
    assert( replaceFilter2.output().connect( upperCaseFilter.input() ) );

    // check some of the connections
    assert( inputPhrase.output().isConnected() );
    assert( replaceFilter1.input(0).isConnected() );
    assert( replaceFilter1.input(1).isConnected() );
    assert( replaceFilter1.input(2).isConnected() );    
    assert( inputPhrase.output().isConnectedTo( replaceFilter1.input(0) ) );
    
    // Update every filter in the right order
    // In the general case, use a NodeGroup, but this is not the object of this test suite
    replaceFilter1.update();
    replaceFilter2.update();
    upperCaseFilter.update();

    // Check the result
    auto partialOutputText1 = cast(PlainTextContainer) replaceFilter1.output().data;
    auto partialOutputText2 = cast(PlainTextContainer) replaceFilter2.output().data;
    auto outputText = cast(PlainTextContainer) upperCaseFilter.output().data;
    
    log.writeln( "input: ", (cast(PlainTextContainer)inputPhrase.output().data).text );
    log.writeln( "Output(0): ", partialOutputText1.text );
    log.writeln( "Output(1): ", partialOutputText2.text );
    log.writeln( "Output(final): ", outputText.text );
    assert(outputText.text == "HELLO WORLD!");
    
}
