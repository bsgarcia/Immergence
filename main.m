function main(recup, debug, simulation)
    if nargin < 3
        simulation = 0;
    end;
    if nargin < 2;
        debug = 0;
    end;
    if nargin < 1;
        recup = 0;
    end;
    KbCheck;
    WaitSecs(0.001); %preloading functions
    startExpTime = GetSecs;
    maxNGames = 1; %6 or maxRounds'length ;
    maxRounds = 201; %30 or %[21 23 18 16 22 23 19 18]; %can be maxRounds=n or maxRounds=[n1 n2 n3] (for 3 games) setting MaxRounds to 0 for 1 or all games will force the game to stop with the fixed probability R.probabilityEndRound [=1/15] at each round
    simulationfirst = 1;
    realExpAftrSim = 1;

    if ~recup
        R = Round(1, debug, simulation, simulationfirst, realExpAftrSim);
    else
        load Round;
        R.Players(R.numberReal).Ptb.initializeWindow;
        load hdata;
        setrandomseed;
    end

    loadseedformdata = (simulation ~= 0 && ~simulationfirst) || (simulation == 0 && realExpAftrSim);


    %if loadseedformdata; RandStream.setDefaultStream(RandStream('mt19937ar','seed',getseedfromdata(R,'lastGameData',maxRounds))); end;
    if loadseedformdata;
        RandStream.setGlobalStream(RandStream('mt19937ar', 'seed', getseedfromdata(R, 'lastGameData', maxRounds)));
    end;

    gameEnd = 0;
    while ~gameEnd
        R.globalRound = R.globalRound + 1;
        cRoundIndex = min(length(maxRounds), R.nGame);
        R.maxRounds = maxRounds(cRoundIndex); %commenting this will force the round to be the last with the fixed probability R.probabilityEndRound [=1/15]
        if R.nGame == maxNGames;
            R.lastGame = 1;
        end;
        R.start;
        [headers, data] = R.save;
        if R.globalRound == 1
            hdata = [headers; data];
        else
            hdata = [hdata; data];
        end
        R.next;
        currentExpTime = GetSecs;
        elapsedTime = currentExpTime - startExpTime;
        hoursElapsed = elapsedTime / 3600;
        if (R.lastGame && R.lastRound);
            gameEnd = 1;
        end;
        if R.nGame == maxNGames;
            R.lastGame = 1;
        end;
        if (hoursElapsed > 2);
            R.lastGame = 1;
            R.lastRound = 1;
        end; %the game will stop if after a time-limit in hours (comment to delete the time-limit)
        save hdata hdata;
        %for recuperation:
        save Round R;
    end
    nowait = 0;
    if recup > 1;
        nowait = 1;
    end;
    compGain = 0;
    hlgain = 0;
    rndStartRound = 0;
    gain10Perc = 0;
    compGain10Perc = 0;
    if simulation == 0
        if realExpAftrSim == 0
            [gamePayed, gain, proba, gainEurSup, totalGain, key, time] = R.Players(R.numberReal).Ptb.infoGains(nowait);
        else
            [gamePayed, tenPercInfo, proba, gainEurSup, hlgain, totalGain, key, time] = R.Players(R.numberReal).Ptb.infoGains2(nowait, R);
            gain = tenPercInfo(1);
            compGain = tenPercInfo(2);
            rndStartRound = tenPercInfo(3);
            gain10Perc = tenPercInfo(4);
            compGain10Perc = tenPercInfo(5);
        end
        dlmwrite('gains.trg', [gamePayed, gain, compGain, rndStartRound, gain10Perc, compGain10Perc, proba, gainEurSup, hlgain, totalGain, key, time], 'delimiter', ';');

    end
    [key, time] = R.Players(R.numberReal).Ptb.endExperiment;
    datafile = ['data_sub', mat2str(R.Players(1).realNumber)];
    save(datafile, 'hdata');
    clear data headers Ptb R maxNRounds startExpTime currentExpTime datafile;
end

function seed = getseedfromdata(R, datafilename, maxRounds)
    load(datafilename);
    eval(['ldata=', datafilename, ';']);
    lds = ldata(ldata.Session == R.session, :);
    seed = lds.randomSeed(lds.realNumber == R.Players(1).realNumber & lds.nRound == maxRounds);
    %display(maxRounds);
    %display(R.Players(1).realNumber);
    if isempty(seed);
        %exit;
        disp(['seed=', mat2str(seed), ', lds.realNumber=', mat2str(lds.realNumber), ', lds.nRound=', mat2str(lds.nRound)])
        %seed=0;
    end
end
