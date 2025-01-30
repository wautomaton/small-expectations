/* This is a macro definition for reading JSON data from a file into a SAS dataset */

%macro read_json(jsonpath, out, appendto);
    
    /* Define a fileref pointing to the JSON file */
    filename jsonfile &jsonpath;
    
    /* Create a SAS dataset named &out */
    data &out;
        
        /* Read the JSON file line by line */
        infile jsonfile lrecl=32767 truncover;
        input jsonLine $char32767.;
        json = jsonLine; /* Store each line in a variable named 'json' */
        
    run;
    
%mend read_json;

%macro read_tabledef(tablemap, target);
    %read_json(&tablemap, work.tabledef_&target)
%mend read_tabledef;

/* 
Macro: read_expectations

Parameters:
- tabledef: Name of the table definition json document
- target: Target table name

Description:
This macro reads JSON data from the 'tabledef' dataset and creates a new dataset 
'work.expects_<target>' with four variables: 'expectation', 'type', 'column', and 'value'.

*/

%macro read_expectations(tabledef, target);
    data work.expects_&target;
        expectation $20;
        type $20;
        column $20;
        value $20;
    run;
    data _null_;
        set work.tabledef_&target;
        rc = %read_json(expects, work.expext, work.expects_&target);
    run;
%mend read_expectations;
