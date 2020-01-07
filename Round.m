classdef Round < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        nRound = 0;
        nGame = 0;
        session = 0;
        lastRound = 0;
        lastGame = 0;
        globalRound = 0;
        nPlayers = 480;
        Proportion = struct;
        simulation = 0;
        groupOf6 = {{'cyan', 'magenta'}, {'yellow', 'magenta'}, {'yellow', 'magenta'}, {'yellow', 'cyan'}, {'magenta', 'cyan'}, {'magenta', 'cyan'}};
        mancheOrders = {};
        usePredefinedPartners = 0;
        choosePartnerAtLastRound = 1;
        playerNumbers = [];
        groups = []; %players' numbers shuffled in 2 columns
        numberReal = 1;
        maxRounds = 0; %if maxRounds=0 the round will terminate acording to the probabilityEndRound;
        probabilityEndRound = 1 / 15; % maxRounds>0 doesn't change anything
        gameRealWallets = [];
        Players = Player.empty;
        saveFileName = 'data.xls';
    end

    methods
        function R = Round(n, debug, simulation, simulationfirst, realExpAftrSim)
            if nargin < 1
                n = 1;
            end
            if nargin < 2;
                debug = 0;
            end;
            if nargin < 3;
                simulation = 0;
            end;
            R.nRound = n;
            R.playerNumbers = 1:R.nPlayers;
            for i = 1:R.nPlayers
                real = 0;
                real(i == R.numberReal) = 1;
                if (i <= R.nPlayers / 3)
                    type = 'cyan';
                elseif (i <= R.nPlayers * 2 / 3)
                    type = 'yellow';
                else
                    type = 'magenta';
                end
                Players(i) = Player(type, real, debug);
                Players(i).number = i;
                Players(i).simulation = simulation;
            end;
            if (exist('session.exe', 'file'));
                R.session = csvread('session.exe');
            end;
            R.Players = Players;
            R.nGame = R.nGame + 1;
            R.simulation = simulation;
            if (simulation == 0 && realExpAftrSim == 0) || (simulation > 0 && simulationfirst)
                setrandomseed(R.Players(1).realNumber);
            end
        end

        function [headers, data] = save(R)
            %saves the data
            currentDate = date;
            headers = [{'Session'}, {'currentDate'}, {'nGame'}, {'nRound'}, {'randomSeed'}, {'lastRound'}];
            %datadeb=[R.session {currentDate} R.nGame R.nRound RandStream.getDefaultStream.Seed R.lastRound];
            datadeb = [R.session{currentDate}, R.nGame, R.nRound, RandStream.getGlobalStream.Seed, R.lastRound];
            data = [];
            for i = 1:R.nPlayers
                if (R.Players(i).real == 0);
                    continue;
                end; %if activated suppresses the non-real players from the data
                playerType = R.Players(i).type;
                numPlayer = R.Players(i).number;
                %numPlayer playerType R.Players(i).real R.Players(i).startGood R.Players(i).partner R.Players(i).proposedGood R.Players(i).willToExchange R.Players(i).goodExchanged R.Players(i).wallet
                playerVars = properties(R.Players(i));
                %playerVars=fieldnames(R.Players(i));
                tempheaders = [];
                datatemp = datadeb;
                vstart = find(strcmp(playerVars, 'real'));
                for v = vstart:length(playerVars) - 3
                    command = strcat('va=R.Players(', sprintf('%d', i), ').', playerVars{v, 1}, ';');
                    eval(command);
                    datatemp = [datatemp{va}];
                    tempheaders = [tempheaders{playerVars{v, 1}}];
                end
                [propheaders, propdata] = R.proportionData();
                datatemp = [datatemp, propdata];
                tempheaders = [tempheaders, propheaders];
                data = [data; datatemp];
            end
            headers = [headers, tempheaders];
            %datafile=['data_sub' R.Players(1).realNumber];
            if R.nRound == 1 && R.nGame == 1
                %cell2csv('header.xls', headers, char(9));
                %save(datafile,'headers');
            end
            %cell2csv(R.saveFileName, data, char(9)); %save(datafile,'data','-append');
            %wallets:
            grwcount = R.nGame;
            if (R.nGame == 1 && R.lastGame);
                grwcount = R.nRound;
            end;
            R.gameRealWallets(grwcount) = R.Players(R.numberReal).wallet;
            gameRealWallets = R.gameRealWallets;
            if R.lastRound;
                save gameRealWallets gameRealWallets;
            end;
        end

        function [headers, data] = proportionData(R)
            headers = [];
            data = [];
            proportionFields1 = fieldnames(R.Proportion);
            for f1 = 1:length(proportionFields1)
                eval(strcat('proportionFields2=fieldnames(R.Proportion.', proportionFields1{f1, 1}, ');'));
                for f2 = 1:length(proportionFields2);
                    eval(strcat('va=R.Proportion.', proportionFields1{f1, 1}, '.', proportionFields2{f2, 1}, ';'));
                    data = [data{va}];
                    headers = [headers{strcat('prop_', proportionFields1{f1, 1}, '_', proportionFields2{f2, 1})}];
                end
            end
        end

        function next(R)
            if R.lastRound
                if R.lastGame;
                    return;
                end;
                R.nGame = R.nGame + 1;
                R.nRound = 1;
                R.lastRound = 0;
            else
                R.nRound = R.nRound + 1;
            end
        end

        function start(R)
            prob = random('unif', 0, 1);
            if (prob < R.probabilityEndRound && R.maxRounds == 0);
                R.lastRound = 1;
            end;
            if (R.nRound == R.maxRounds);
                R.lastRound = 1;
            end;
            if R.nGame == 1 && R.nRound == 1 && R.numberReal > 0 && R.simulation == 0
                R.Players(R.numberReal).Ptb.introduction;
            end
            for i = 1:R.nPlayers
                if R.nGame > 1 && R.nRound == 1
                    R.Players(i).reinitialize();
                else
                    R.Players(i).resetCurrentState();
                end
            end
            if R.nRound == 1 && R.numberReal > 0
                maxgroups = 5;
                permutationMade = 0;
                if (~R.usePredefinedPartners);
                    permutationMade = 1;
                end;
                while ~permutationMade
                    if R.maxRounds ~= 0;
                        maxgroups = ceil(R.maxRounds/size(R.groupOf6, 2));
                    end;
                    for i = 1:maxgroups;
                        if (i == 1);
                            R.mancheOrders = R.groupOf6(:, randperm(size(R.groupOf6, 2)));
                        else R.mancheOrders = [R.mancheOrders, R.groupOf6(:, randperm(size(R.groupOf6, 2)))];
                        end;
                    end;
                    permutationMade = 1;
                    if (strcmp(R.mancheOrders{R.nRound}{1}, 'cyan') && strcmp(R.mancheOrders{R.nRound}{2}, 'magenta'));
                        permutationMade = 0;
                    end;
                    if (strcmp(R.mancheOrders{R.nRound}{1}, 'yellow') && strcmp(R.mancheOrders{R.nRound}{2}, 'cyan'));
                        permutationMade = 0;
                    end;
                end
            end
            R.Players(R.numberReal).Ptb.nRound = R.nRound;
            R.Players(R.numberReal).Ptb.nGame = R.nGame;
            R.Players(R.numberReal).Ptb.lastGame = R.lastGame;
            goodPartner = 0;
            tgroups = [];
            partnerType = '';
            if (R.usePredefinedPartners);
                partnerType = R.mancheOrders{R.nRound}{1};
            end;
            if R.numberReal > 0 && R.simulation == 0 && R.choosePartnerAtLastRound && R.lastRound && R.lastGame
                partnerType = R.Players(R.numberReal).Ptb.choosePartner;
            end
            if R.numberReal > 0 && R.simulation >= 2 && R.choosePartnerAtLastRound && R.lastRound && R.lastGame
                partnerType = R.Players(R.numberReal).myGood();
            end
            while goodPartner == 0
                matching = randperm(R.nPlayers);
                tgroups = reshape(matching, 2, R.nPlayers/2)';
                if (strcmp(partnerType, '') || R.numberReal <= 0);
                    goodPartner = 1;
                    break;
                end; %if(~R.usePredefinedPartners || R.numberReal<=0)
                s = size(tgroups);
                ngroups = s(1);
                for g = 1:ngroups
                    group = tgroups(g, :);
                    p1 = group(1);
                    p2 = group(2);
                    if (R.Players(p1).real && strcmp(R.Players(p2).type, partnerType));
                        goodPartner = 1;
                    end;
                    if (R.Players(p2).real && strcmp(R.Players(p1).type, partnerType));
                        goodPartner = 1;
                    end;
                end
            end
            R.groups = tgroups;
            s = size(R.groups);
            ngroups = s(1);
            if (R.usePredefinedPartners);
                partnerGood = R.mancheOrders{R.nRound}{2};
            end;
            if (R.usePredefinedPartners)
                for g = 1:ngroups
                    group = R.groups(g, :);
                    p1 = group(1);
                    p2 = group(2);
                    if (R.Players(p1).real);
                        R.Players(p1).initPartGood = R.Players(p2).myGood();
                        R.Players(p2).forceExchange(partnerGood);
                    end;
                    if (R.Players(p2).real);
                        R.Players(p2).initPartGood = R.Players(p1).myGood();
                        R.Players(p1).forceExchange(partnerGood);
                    end;
                end
            end
            R.computeProportion();
            R.meet();
        end

        function R = meet(R)
            s = size(R.groups);
            ngroups = s(1);
            for g = 1:ngroups
                group = R.groups(g, :);
                p1 = group(1);
                p2 = group(2);
                R.Players(p1).group = g;
                R.Players(p2).group = g;
                R.Players(p1).partner = p2;
                R.Players(p2).partner = p1;
                R.Players(p1).partnersType = R.Players(p2).type;
                R.Players(p2).partnersType = R.Players(p1).type;
                good1 = R.Players(p1).myGood();
                good2 = R.Players(p2).myGood();
                R.Players(p1).startGood = good1;
                R.Players(p2).startGood = good2;
                R.Players(p1).proposedGood = good2;
                R.Players(p2).proposedGood = good1;
                % will1=R.Players(p1).shouldIExchange(good2,R.Proportion); will2=R.Players(p2).shouldIExchange(good1,R.Proportion);
                will1 = R.Players(p1).shouldIExchange(good2, R);
                will2 = R.Players(p2).shouldIExchange(good1, R);
                R.Players(p1).willToExchange = will1;
                R.Players(p2).willToExchange = will2;
                R.Players(p1).goodExchanged = 0;
                R.Players(p2).goodExchanged = 0;
                R.Players(p1).tellPartnersWill(will2);
                R.Players(p2).tellPartnersWill(will1);
                %for debug
                if isempty(will1)
                    R.Players(p1)
                    will1
                end
                if isempty(will2)
                    R.Players(p1)
                    will2
                end
                %end for debug
                if (will1 && will2)
                    R.Players(p1).exchange(good2, R);
                    R.Players(p2).exchange(good1, R);
                else
                    R.Players(p1).payStock(R);
                    R.Players(p2).payStock(R);
                end
            end
        end

        function R = computeProportion(R)
            R.resetProportion();
            possibleGoods = R.Players(1).possibleGoods;
            possibleTypes = R.Players(1).possibleTypes;
            for t = 1:length(possibleTypes)
                ctype = possibleTypes(t);
                ct = ctype{1, 1};
                ct(1) = upper(ct(1));
                uctype = ct;
                for g = 1:length(possibleGoods)
                    cgood = possibleGoods(g);
                    cg = cgood{1, 1};
                    cg(1) = upper(cg(1));
                    ucgood = cg;
                    for p = 1:R.nPlayers
                        if (strcmp(R.Players(p).type, ctype) && strcmp(R.Players(p).myGood(), cgood))
                            command1 = strcat('R.Proportion.p', uctype, '.g', ucgood, 'Number=R.Proportion.p', uctype, '.g', ucgood, 'Number+1;');
                            command2 = strcat('R.Proportion.p', uctype, '.g', ucgood, '=R.Proportion.p', uctype, '.g', ucgood, 'Number/R.Proportion.p', uctype, '.number;');
                            eval(command1);
                            eval(command2);
                        end
                    end
                end
            end
        end

    end


    methods (Hidden)

        function R = resetProportion(R)
            possibleGoods = R.Players(1).possibleGoods;
            possibleTypes = R.Players(1).possibleTypes;
            for t = 1:length(possibleTypes)
                ctype = possibleTypes(t);
                ct = ctype{1, 1};
                ct(1) = upper(ct(1));
                for g = 1:length(possibleGoods)
                    cgood = possibleGoods(g);
                    cg = cgood{1, 1};
                    cg(1) = upper(cg(1));
                    command1 = strcat('R.Proportion.p', ct, '.g', cg, 'Number=0;');
                    command2 = strcat('R.Proportion.p', ct, '.g', cg, '=0;');
                    eval(command1);
                    eval(command2);
                end
                pTypes = cell(1, R.nPlayers);
                [pTypes{:}] = R.Players.type;
                nctype = length(pTypes(strcmp(pTypes, ctype)));
                command = strcat('R.Proportion.p', ct, '.number=nctype;');
                eval(command);
            end
        end

    end


end
