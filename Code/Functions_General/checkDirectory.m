%% Script to check working directory is correct.
function checkDirectory()
    pat = "ODE_Modelling_Suite";
    str = string(pwd);
    
    if(~contains(str,pat))
        error("Please ensure the working directory is in ODE_Modelling_Suite");
    end
end
