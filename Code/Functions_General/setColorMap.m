%% Script to generate a series of colour maps 
function colorMapMatrix = setColorMap(colorMap)

switch colorMap
    case 'natureBlueMap'
    colorMapMatrix = [linspace(1,0.23,255)',... %RED
    linspace(1,0.32,255)',... %GREEN
    linspace(1,0.65,255)']; %BLUE

    case 'natureRedMap'
    colorMapMatrix  = [linspace(0.9,0.93,255)',... %RED
    linspace(0.9,0.13,255)',... %GREEN
    linspace(0.9,0.14,255)']; %BLUE
    
    case 'natureSoftGreenMap'
    colorMapMatrix  = [linspace(0.9,0.63,255)',... %RED
    linspace(0.9,0.69,255)',... %GREEN
    linspace(0.9,0.54,255)']; %BLUE

    case 'natureRedSplitMap'
    colorMapMatrix = [[linspace(0.93,0.9,127)';linspace(0.9,0.93,128)'],... %RED
    [linspace(0.13,0.9,127)';linspace(0.9,0.13,128)'],... %GREEN
    [linspace(0.14,0.9,127)';linspace(0.9,0.14,128)']]; %BLUE

    case 'natureRedBlueMap'
    colorMapMatrix  = [linspace(0.93,0.23,255)',... %RED
    linspace(0.13,0.32,255)',... %GREEN
    linspace(0.14,0.65,255)']; %BLUE

    case 'natureRedBlueHeatMap'
    colorMapMatrix= [[linspace(0.93,0.23,127)';linspace(0.93,0.23,128)'],... %RED
    [linspace(0.13,0.32,127)';linspace(0.13,0.32,128)'],... %GREEN
    [linspace(0.14,0.65,127)';linspace(0.14,0.65,128)']]; %BLUE

    case 'naturePurpGreenHeatMap'
    colorMapMatrix= [[linspace(0.33,0.48,127)';linspace(0.33,0.48,128)'],... %RED
    [linspace(0.83,0.00,127)';linspace(0.83,0.00,128)'],... %GREEN
    [linspace(0.27,0.54,127)';linspace(0.27,0.54,128)']]; %BLUE

    case 'naturePurpSilverHeatMap'
    colorMapMatrix = [[linspace(0.78,0.42,127)';linspace(0.78,0.42,128)'],... %RED
    [linspace(0.78,0.33,127)';linspace(0.78,0.33,128)'],... %GREEN
    [linspace(0.79,0.55,127)';linspace(0.79,0.55,128)']]; %BLUE

    case 'natureRedGreyHeatMap'
    colorMapMatrix  = [[linspace(0.38,1,127)';linspace(0.38,1,128)'],... %RED
    [linspace(0.38,0.00,127)';linspace(0.38,0.00,128)'],... %GREEN
    [linspace(0.38,0.00,127)';linspace(0.38,0.00,128)']]; %BLUE

    case 'natureBlueGreyHeatMap'
    colorMapMatrix   = [[linspace(0.38,0,127)';linspace(0.38,0,128)'],... %RED
    [linspace(0.38,0.00,127)';linspace(0.38,0.00,128)'],... %GREEN
    [linspace(0.38,1,127)';linspace(0.38,1,128)']]; %BLUE

    case 'natureRedWhiteBlueMap'
    colorMapMatrix    = [[linspace(0.93,1,128)';linspace(1,0.23,127)'],... %RED
    [linspace(0.13,1,128)';linspace(1,0.32,127)'],... %GREEN
    [linspace(0.14,1,128)';linspace(1,0.65,127)']]; %BLUE

    case 'natureBlueWhiteRedMap'
    colorMapMatrix     = [[linspace(0.23,1,128)';linspace(1,0.85,127)'],... %RED
    [linspace(0.13,1,128)';linspace(1,0.32,127)'],... %GREEN
    [linspace(0.85,1,128)';linspace(1,0.23,127)']]; %BLUE

    case 'natureOrangeMap'
    colorMapMatrix= [linspace(1,0.91,255)',... %RED
    linspace(1,0.55,255)',... %GREEN
    linspace(1,0.18,255)']; %BLUE

    case 'colourOrderSunset'
    colorMapMatrix = { '#08183A', '#152852', '#4B3D60', '#FD5E53', '#FC9C54', '#FFE373' };

    case 'colourOrderEnglishViolet'
    colorMapMatrix= [linspace(1,0.29,20)',... %RED
    linspace(1,0.23,20)',... %GREEN
    linspace(1,0.37,20)']; %BLUE
    
    case 'colourOrderSunsetOrange'
    colorMapMatrix= [linspace(1,0.99,20)',... %RED
    linspace(1,0.36,20)',... %GREEN
    linspace(1,0.32,20)']; %BLUE
    
    case 'colourOrderSandyBrown'
    colorMapMatrix= [linspace(1,0.98,20)',... %RED
    linspace(1,0.61,20)',... %GREEN
    linspace(1,0.32,20)']; %BLUE

    case 'colourOrderShandy'
    colorMapMatrix= [linspace(1,1,20)',... %RED
    linspace(1,0.89,20)',... %GREEN
    linspace(1,0.45,20)']; %BLUE

    case 'colourOrderRed'
    colorMapMatrix= [linspace(1,0.9,20)',... %RED
    linspace(0,0.9,20)',... %GREEN
    linspace(0,0.9,20)']; %BLUE
    
    case 'colourOrderBlue'
    colorMapMatrix= [linspace(0,1,10)',... %RED
    linspace(0,1,10)',... %GREEN
    linspace(1,1,10)']; %BLUE

    case 'colourOrderDosingRed'
        colorMapMatrix = {'#FFEBEB', '#FFC2C2', '#FF9999', '#FF7070','#FF4747',...
            '#FF1F1F','#F50000','#CC0000','#A30000','#7A0000'};
    
    case 'colourOrderDosingYellowToRed'
        colorMapMatrix = {'#FFEEC2', '#FFDD99', '#FFC05C', '#FFAF47','#FF9C33',...
            '#FF9233','#FF801F','#F55E00','#CC4400','#521700'};
    
    case 'colourOrderDosingYellowToRed_WT'
        colorMapMatrix = {'#000000','#FFEEC2', '#FFDD99', '#FFC05C', '#FFAF47','#FF9C33',...
            '#FF9233','#FF801F','#F55E00','#CC4400','#521700'};

    case 'colourOrderTriple'
        colorMapMatrix = {'#264653', '#2a9d8f', '#e76f51'};
    
    % yellow to green to blue colour palette.
    case 'viridis5'
        colorMapMatrix = {  "#440154", "#3b528b", "#21918c", "#5ec962", "#fde725"};

    case 'viridis10' 
        colorMapMatrix = {  "#440154", "#482878", "#3e4989", "#31688e", "#26828e",...
                            "#1f9e89", "#35b779", "#6ece58", "#b5de2b", "#fde725"};
    case 'viridis20'
        colorMapMatrix = {  "#440154", "#481567", "#482677", "#453781", "#404788",...
                            "#39568C", "#33638D", "#2D708E", "#287D8E", "#238A8D",...
                            "#1F958B", "#20A387", "#29AF7F", "#3CBB75", "#55C667",...
                            "#73D055", "#95D840", "#B8DE29", "#DCE319", "#FDE725"};
    case 'viridis50'
        colorMapMatrix = {  "#440154", "#46085c", "#471063", "#481769", "#481d6f",...
                            "#482576", "#472c7a", "#46327e", "#453882", "#423f85",...
                            "#404588", "#3e4a89", "#3c508b", "#39558c", "#365c8d",...
                            "#34618d", "#31668e", "#2f6b8e", "#2d718e", "#2b758e",...                      
                            "#2b758e", "#277f8e", "#25838e", "#23898e", "#218e8d",...
                            "#20928c", "#1f978b", "#1e9d89", "#1fa187", "#21a685",...
                            "#25ab82", "#29af7f", "#31b57b", "#38b977", "#40bd72",...
                            "#4ac16d", "#56c667", "#60ca60", "#6ccd5a", "#77d153",...
                            "#84d44b", "#93d741", "#a0da39", "#addc30", "#bade28",...
                            "#cae11f", "#d8e219", "#e5e419", "#f1e51d", "#fde725"};

    otherwise
end
