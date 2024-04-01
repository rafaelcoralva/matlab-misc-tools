function [xData, timeData] = executionTime(modelName, varargin)
% EXECUTIONTIME Simulate a Simulink model a number of times and record the execution time.
%   Plots the results and shows the min, max, and mean times.
%
% Inputs:
%   modelName       Name of the model to be simulated, as a char array or string.
%
% Optional Input Pairs:
%   PARAMETER       VALUES              DESCRIPTION
%   nSims           pos. integers       Number of simulations to run. (Default is 1)
%   DiscardFirst    [true | (false)]    The first simulation usually takes
%                                       longer due to factors related to model
%                                       compilation. If set to true, the first
%                                       measurement is discarded.
%
%   Plot            [(true) | false]    Plot the results.
%
% Outputs:
%   xData           Simulation number.
%   timeData        Duration of simulation in milliseconds.
%
% Examples:
%   Simulate the model 100 times.
%   executionTime('sldemo_boiler', 'nSims', 100)           
%
%   Simulate the currently selected model 100 times, but discard the first measurement
%   executionTime(gcs, 'nSims', 100, 'DiscardFirst', true) 
%                                                  
% Author: Monika Jaskolka

    unloadFlag  = false;
    
    % Get arguments
    nSims = getInput('nSims', varargin, 1);
    discardFirst = getInput('DiscardFirst', varargin, 0);
    plotResults = getInput('Plot', varargin, 0);

    %% Check arguments
    if nargin < 1
        error('Not enough inputs.');
    end

    % 1) Check number of simulations
    if ~isnumeric(nSims) || nSims <= 0
         error('Invalid number of simulations. Please select a positive integer.');
    end

    % 2) Check model argument
    if exist(modelName, 'file') ~= 4 && exist(modelName, 'file') ~= 2
        disp(exist(modelName, 'file'));
        error('''%s'' is an invalid file or does not exist.', modelName);
    else
        if ~bdIsLoaded(modelName)
            load_system(modelName);
            unloadFlag = true;
        end
    end

    %% Simulate
    % If we are scrapping the first measurement, then need to do one extra
    if discardFirst
        nSims2 = nSims+1;
    else
        nSims2 = nSims;
    end

    timeData = zeros(1, nSims2); % Preallocate array

    % Perform simulations
    fprintf('Running %d simulation(s)', nSims);
    for i = 1:nSims2
        if mod(i, 2) == 0
            fprintf('.');
        end
        tic;
        sim(modelName);
        timeData(i) = toc;
    end
    fprintf('\n');

    % Remove first measurement
    if discardFirst
        timeData = timeData(2:end);
    end

    % Convert time to milliseconds
    timeData = timeData .* 1000;

    % Construct x-axis (simulation #)
    xData = 1:nSims;

    %% Plot
    if plotResults
        plot(xData, timeData, '-')
        legendString = {'Actual'};

        % Plot mean line
        hold on
        z = mean(timeData) * ones(1, nSims);
        plot(xData, z, '-r')
        hold off

        % Compute mean, max, min
        t_mean         = mean(timeData);
        [t_max, i_max] = max(timeData);
        [t_min, i_min] = min(timeData);
        s1 = ['Mean: ' , num2str(round(t_mean)), ' ms'];
        s2 = ['Worst: ', num2str(round(t_max)) , ' ms'];
        s3 = ['Best: ' , num2str(round(t_min)) , ' ms'];

        hold on
        plot(xData(i_max), timeData(i_max), 'r*')
        plot(xData(i_min), timeData(i_min), 'ro')
        hold off

        legendString{end+1} = s1;
        legendString{end+1} = s2;
        legendString{end+1} = s3;

        % Format figure/plot
        title('Model Simulation Performance');
        grid on
        xlabel('Simulation #');
        ylabel('Duration (ms)');
        legend(legendString, 'Location', 'northeast');
    end

    if unloadFlag
        save_system
        close_system(modelName);
    end
end

function value = getInput(name, args, default)
% GETINPUT Get a specific input from a list of arguments from varargin.
%
%   Inputs:
%       name    Char array of the input name.
%       args    Cell array of all arguments pass in via varargin.
%       default Value to return if input not in list of arguments. (Optional)
%               Default is [].
%
%   Outputs:
%       value   Value of the input specified by the input name.
%
%   Example:
%       >> getInput('BlockType', {'Name', 'Example', 'BlockType', 'SubSystem'})
%           ans =
%               'SubSystem'
%
%       >> getInput('otherFiles', {'imageFile', 'test.png', 'otherFiles', {'file1', 'file2'}})
%           ans =
%               1x2 cell array
%                   {'file1'}    {'file2'}
%
%   Requires: iscellcell.m

    if nargin == 2
        default = [];
    else
        assert(nargin == 3, 'Error: Expecting 2 or 3 inputs.')
    end

    if iscellcell(args)
        idx = find(strcmp(args, name));
        exists = ~isempty(idx);
    else
        args2 = cellfun(@num2str, args, 'un', 0);
        [exists, idx] = ismember(name, args2);
    end

    if exists && length(args) > idx
        value = args{idx+1};
    else
        value = default;
    end
end

function b = iscellcell(c)
% ISCELLCELL Whether the input is a cell array containing at least another cell.
%
%   Inputs:
%       c   Cell array.
%
%   Outputs:
%       b   Whether the it is a cell array of cells(1) or not(0).
%
%   Example:
%       iscellcell({'a'})
%           ans = 0
%
%       iscellcell({{'a'}, {'b'}})
%           ans = 1

    b = false;
    if iscell(c)
        for i = 1:length(c)
            if iscell(c{i})
                b = true;
            end
        end
    end
end