/* For each row in the tabledef test the column in the target table.*/
%macro expectation_tester(target, column, type, value);
    data work.expects_&target;
        /*try ifn/ifc*/
    run;
    work.expectations_&target
%mend expectation_tester;