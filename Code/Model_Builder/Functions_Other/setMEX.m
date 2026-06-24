%% Set Mex options.
function mex_options = setMEX()

mex_options.maxnumsteps = 1000;
mex_options.abstol      = 1e-9;
mex_options.reltol      = 1e-9;
mex_options.tss_check   = @(x) logical(sum((abs(x(end-1,x(end,:)>1e-3) - ...
    x(end,x(end,:)>1e-3))./x(end,x(end,:)>1e-3) > 1e-3) + (x(end,x(end,:)>1e-3)) < -1e-10));

end