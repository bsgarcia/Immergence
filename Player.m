classdef Player <handle
    %Player Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        possibleGoods={'cyan', 'yellow', 'magenta'}; %{'cyan', 'yellow', 'magenta', 'cmagenta'} for perishable;
        possibleTypes={'cyan', 'yellow', 'magenta'};
        payOwnGood=0;
        perishable=0;
        perishtype='magenta';
        noStockCost=0;
        forceSpeculativeEquilibriumWhenPerishable=1;
        quitIfInsufficientFunds=0;
        productionCost=0;
        consumptionBenefit=100;
        
    end
    properties (SetAccess = private)
        alreadyProduced=0;
        alreadyPerished=0;
        stock=struct;
        real=0;
        type='';
    end
    properties
        computerName='';
        realNumber='';
        number=0;
        group=0;
        partner=0;
        partnersType='';
        wallet=100;
        proportionReactionTime=0;
        proportionKey=-1;
        pointsReactionTime=0;
        pointsKey=-1;
        willToExchange=0;
        willReactionTime=0;
        willConfirmReactionTime=0;
        firstWillToExchange=0;
        firstWillReactionTime=0;
        firstWillConfirmReactionTime=0;
        overallWillTime=0;
        nWillChanged=0;
        partnersWillToExchange='';
        goodExchanged=0;
        goodConsumed=0;
        newGoodProduced=0;
        goodPerished=0;
        proposedGood='';
        startGood='';
        %newGood='';
        finalGood='';
        initPartGood='';
        optimalBehavior='';
        optimalWill=-1;
        cyanAlwaysSpeculative=0;
        startWallet=100;
        currentConsumption=0;
        currentStockCost=0;
        currentProdCost=0;
        insufficientFunds=0;
		randomGroup=0;
		randGrLeftPlayer=0;
		randGrRightPlayer=0;
		randGrLeftType='';
		randGrLeftGood='';
		randGrRightType='';
		randGrRightGood='';
		randGrLeftAccepts=-1;
		randGrRightAccepts=-1;
        simulation=0;
        discountFactor=0.995;
        utility=Player.consumptionBenefit;
        Ptb;
    end
   
    methods
         function Pl =Player(type,realornot,debug)
             if(nargin<3); debug=0; end;
             Pl.type=type;
             Pl.real=realornot;
             if Player.perishable; Pl.cyanAlwaysSpeculative=Player.forceSpeculativeEquilibriumWhenPerishable; end;
             Pl.resetStock();
             Pl.produce();
             [Pl.realNumber Pl.computerName]=Pl.getRealNumber();
             if Pl.real
                 Pl.Ptb=Interface(type,debug);
                 Pl.Ptb.myGoodColor=Pl.myGood();
             end
         end
         
         function reinitialize(Pl)
             Pl.alreadyProduced=0;
             Pl.wallet=100; Pl.resetStock(); Pl.produce();
             %if Pl.real; Pl.Ptb.myGoodColor=Pl.myGood(); Pl.Ptb.wallet=Pl.wallet; end; % - in Player.resetCurrentState();
             Pl.resetCurrentState;
         end
         
         function resetCurrentState(Pl)
             %Pl.perishPerishable(); % - in Player.payStock():
             Pl.alreadyProduced=0; Pl.alreadyPerished=0;
             Pl.startGood=Pl.myGood(); Pl.optimalBehavior=''; Pl.currentConsumption=0 ; Pl.currentStockCost=0; Pl.currentProdCost=0;
             Pl.optimalWill=-1; Pl.proposedGood=''; Pl.goodExchanged=0; Pl.goodConsumed=0; Pl.newGoodProduced=0; Pl.goodPerished=0;
             Pl.partnersWillToExchange='';  Pl.finalGood=''; %Pl.newGood='';
             Pl.willToExchange=0; Pl.partner=0; Pl.group=0;
             Pl.proportionReactionTime=0; Pl.proportionKey=-1; Pl.pointsReactionTime=0; Pl.pointsKey=-1; Pl.willToExchange=0;
             Pl.willReactionTime=0; Pl.willConfirmReactionTime=0; Pl.firstWillToExchange=0; Pl.firstWillReactionTime=0;
             Pl.firstWillConfirmReactionTime=0; Pl.nWillChanged=0; Pl.insufficientFunds=0;
             Pl.startWallet=Pl.wallet;
             if Pl.real; Pl.Ptb.myGoodColor=Pl.myGood(); Pl.Ptb.wallet=Pl.wallet; Pl.Ptb.startWallet=Pl.wallet; end;
         end
         
         function Pl=resetStock(Pl)
              %Pl.stock.gYellow=0; Pl.stock.gCyan=0; Pl.stock.gMagenta=0;
              for i=1:length(Pl.possibleGoods)
                cgood=Pl.possibleGoods{i};
                ugood=cgood; ugood(1)=upper(ugood(1));
                command=['Pl.stock.g' ugood '=0;'];
                eval(command);
              end
         end
         
         function Pl=produce(Pl)
           if Pl.alreadyProduced; return; end;
           [bidon, production]=Pl.goodProduced(Pl.type);
           command=['Pl.stock.g' production '=Pl.stock.g' production '+1;'];
           eval(command);
           Pl.currentProdCost=Pl.productionCost;
           Pl.wallet=Pl.wallet-Pl.currentProdCost;
           %if Pl.real; fprintf('wallet in produce()= %d; ',Pl.wallet); end;
           %Pl.newGood=Pl.myGood();
           if Pl.real; Pl.Ptb.wallet=Pl.wallet; Pl.Ptb.myGoodColor=Pl.myGood(); end;
           Pl.newGoodProduced=1;
           Pl.alreadyProduced=1;
         end
         
         function good=myGood(Pl)
             for i=1:length(Pl.possibleGoods)
                 cgood=Pl.possibleGoods{i};
                 ugood=cgood; ugood(1)=upper(ugood(1));
                 command=['cond0=Pl.stock.g' ugood '>0;'];
                 %Pl.number
                 eval(command);
                 if(cond0)
                     good=cgood;
                 end
             end
%              if Pl.stock.gYellow>0
%                  good='yellow';
%              end
%              if Pl.stock.gCyan>0
%                  good='cyan';
%              end
%              if Pl.stock.gMagenta>0
%                  good='magenta';
%              end
         end
		 
		 function t=myType(Pl)
			t=Pl.type
		 end
         
         function Pl=obtain(Pl,good)
             ugood=good; ugood(1)=upper(ugood(1));
             command=['Pl.stock.g' ugood '=Pl.stock.g' ugood '+1;'];
             eval(command);
%              switch(good)
%                  case 'yellow'
%                      Pl.stock.gYellow=Pl.stock.gYellow+1;
%                  case 'magenta'
%                      Pl.stock.gMagenta=Pl.stock.gMagenta+1;
%                  case 'cyan'
%                      Pl.stock.gCyan=Pl.stock.gCyan+1;
%              end
             %Pl.newGood=Pl.myGood();
             if Pl.real; Pl.Ptb.myGoodColor=Pl.myGood(); end;
         end
          
         function Pl=consume(Pl)
             Pl.wallet=Pl.wallet+Pl.utility;
             Pl.currentConsumption=Pl.utility;
             if Pl.real; Pl.Ptb.wallet=Pl.wallet; end;
             if Pl.payOwnGood
                command=['Pl.stock.g' Pl.myTypeGood() '=Pl.stock.g' Pl.myTypeGood() '+1;']; eval(command); % new instead of Pl.produce();
             else
                Pl.produce();
             end
             Pl.goodConsumed=1;
        end
         
         function Pl=payStock(Pl,R)
             if Pl.real; Pl.Ptb.startGoodColor=Pl.myGood(); end;
             if nargin<2; R=struct; end;
             if length(fieldnames(R))==0; R.lastRound=0; R.lastGame=0; end; %#ok<ISMT>
             c=0;
             for i=1:length(Pl.possibleGoods)
                 cgood=Pl.possibleGoods{i};
                 ugood=cgood; ugood(1)=upper(ugood(1));
                 ccost=Pl.cost(cgood); %#ok<NASGU>
                 command=['c=c+Pl.stock.g' ugood '*ccost;'];
                 eval(command);
             end
%              c=c+Pl.stock.gCyan*Pl.cost('cyan');
%              c=c+Pl.stock.gYellow*Pl.cost('yellow');
%              c=c+Pl.stock.gMagenta*Pl.cost('magenta');
             Pl.currentStockCost=c;
             Pl.wallet=Pl.wallet-Pl.currentStockCost;
             
             if (Pl.payOwnGood && Pl.goodConsumed && ~Pl.alreadyProduced); %if consumed
                 Pl.resetStock(); 
                 Pl.produce(); 
             end; %new
             
             
             if(Pl.perishable && ~(strcmp(Pl.perishtype,Pl.goodProduced(Pl.type)) && Pl.alreadyProduced)); Pl.perishPerishable(); end;
             Pl.finalGood=Pl.myGood();
             
             %if Pl.real; fprintf('wallet in payStock= %d. ',Pl.wallet);  disp('\n'); end;
             if Pl.wallet<0 && Pl.quitIfInsufficientFunds; Pl.insufficientFunds=1; end;
            
             if Pl.real
                 if Pl.insufficientFunds
                     Pl.wallet=0; R.lastRound=1;
                 end
                 Pl.Ptb.wallet=Pl.wallet;
                 if Pl.simulation==0; [Pl.pointsKey Pl.pointsReactionTime]=Pl.Ptb.showPoints(Pl.currentConsumption,Pl.currentStockCost,Pl.currentProdCost,Pl,R); end;
             end

         end
         
         
         function Pl=perishPerishable(Pl)
             if Pl.alreadyPerished; return; end;
             perishUgood=''; %perishgood=''; 
              for i=1:length(Pl.possibleGoods)
                 cgood=Pl.possibleGoods{i};
                 ugood=cgood; ugood(1)=upper(ugood(1));
                 if strcmp(cgood(2:end),Pl.perishtype)
                      perishUgood=ugood; %perishgood=cgood;
                 end
              end
              command=['cond0=Pl.stock.g' perishUgood '>0;'];
              eval(command);
              if(cond0)
                 command=['Pl.stock.g' perishUgood '=0;'];
                 eval(command);
                 Pl.goodPerished=1; Pl.alreadyPerished=1;
                 Pl.produce();
              end
              if ((strcmp(Pl.perishtype,Pl.goodProduced(Pl.type)) && Pl.alreadyProduced)); return; end;
              perishTypeUGood=Pl.perishtype; perishTypeUGood(1)=upper(perishTypeUGood(1));
              command=['cond2=Pl.stock.g' perishTypeUGood '>0;'];
              eval(command);
              if(cond2)
                 command=['Pl.stock.g' perishTypeUGood '=0;' ' Pl.stock.g' perishUgood '= Pl.stock.g' perishUgood '+1;'];
                 eval(command);
              end
              if Pl.real; Pl.Ptb.myGoodColor=Pl.myGood(); end;
              Pl.alreadyPerished=1;
         end
        

         function Pl=forceExchange(Pl,newGood)
             if (strcmp(Pl.type,newGood) || strcmp(['c' Pl.type],newGood))
                 Pl.resetStock();
                 Pl.consume();
             else
                 Pl.resetStock();
                 Pl.obtain(newGood);
             end
         end

         
         function Pl=exchange(Pl,proposedGood,R)
             if nargin<2; R=struct; end;
             if Pl.real && Pl.simulation==0; Pl.Ptb.animExchange(Pl.partnersType,proposedGood); end;
             consumed=strcmp(Pl.type,proposedGood) || strcmp(Pl.type,proposedGood(2:end));
             if (consumed)
                 Pl.resetStock();
                 Pl.consume();
             else
                 Pl.resetStock();
                 Pl.obtain(proposedGood);
             end
             Pl.payStock(R);
%              if (Pl.payOwnGood && consumed && ~Pl.alreadyProduced); %if
%              consumed - in Player.payStock(R)
%                  Pl.resetStock(); 
%                  Pl.produce(); 
%              end; %new
             Pl.goodExchanged=1;
         end
         
         
         
         function will = shouldIExchange(Pl,proposedGood,R)
             if nargin<3
				 R=struct;
                 Proportion=0;
			 else
				 Proportion=R.Proportion
             end
             startWillTime=GetSecs;
             myCurrentGood=Pl.myGood();
             proposedGoodWillPerish=strcmp(proposedGood(2:end),Pl.perishtype);
             myGoodWillPerishAndProposedNot=(Pl.perishable && strcmp(myCurrentGood(2:end),Pl.perishtype) && ~proposedGoodWillPerish);
             proposedGoodIsOfMyType=(strcmp(Pl.type,proposedGood) || strcmp(Pl.type,proposedGood(2:end)));
             myCurrentGoodIsOfMyType=(strcmp(Pl.type,myCurrentGood) || strcmp(Pl.type,myCurrentGood(2:end)));
             if strcmp(Pl.type,'cyan')
                 switch proposedGood
                     case Pl.type
                         w=1;
                     case 'magenta'
                         Pl.setMyBehavior(Proportion);
                         w(strcmp(Pl.optimalBehavior,'fundamental'))=0;
                         w(strcmp(Pl.optimalBehavior,'speculative'))=1;
                         Pl.optimalWill=w;
                         if Pl.cyanAlwaysSpeculative; w=1; end;
                     otherwise
                         w=0;
                 end
              else
                 if proposedGoodIsOfMyType
                     w=1;
                 elseif ~Pl.noStockCost && ~Pl.perishable && Pl.cost(proposedGood)<Pl.cost(Pl.myGood())
                     w=1;
                 elseif Pl.perishable && Pl.noStockCost && strcmp(myCurrentGood,Pl.perishtype) && ~proposedGoodWillPerish
                     w=1; %it is more interesting for Yellow (type2) to change magenta (type 3, perishable at the next round) against cyan (type 1) wich is not perishable
                 elseif  Pl.perishable && Pl.noStockCost && strcmp(Pl.type,Pl.perishtype)
                     percOk=0; r=rand; w(r<percOk)=1; w(r>=percOk)=0; %for Magenta (type 3) it is indifferent wether to exchange against yellow or cyan (type 2 or 1) or not;
                     w(Player.forceSpeculativeEquilibriumWhenPerishable>0)=0;
                 else
                     w=0;
                 end
             end
             if(Pl.noStockCost && myGoodWillPerishAndProposedNot); w=1; end;
             if strcmp(myCurrentGood,proposedGood); w=0; end;
             if myCurrentGoodIsOfMyType; w=0; end;
             if ~(strcmp(Pl.type,'cyan') && strcmp(proposedGood,'magenta')); Pl.optimalWill=w; end;
             if Pl.real && Pl.simulation==0
                 w=Pl.Ptb.shouldIExchange(Pl.partnersType,proposedGood,Proportion,Pl,R);
             end
             if Pl.real && Pl.simulation==3; w=Pl.optimalWill; end; %2
             if Pl.real && Pl.simulation==1; w=1; end;
             if Pl.real && Pl.simulation==-1; w=0; end;
             if Pl.real && Pl.simulation==0.5; w=0; w((strcmp(Pl.type,proposedGood) || strcmp(Pl.type,proposedGood(2:end))) || Pl.cost(proposedGood)<Pl.cost(Pl.myGood) || myGoodWillPerishAndProposedNot)=1; end;
             will=w;
             if ~Pl.real || Pl.simulation~=0; endWillTime=GetSecs; Pl.overallWillTime=endWillTime-startWillTime; end;
         end
         
         
         
         function tellPartnersWill(Pl,will)
             Pl.partnersWillToExchange=will;
             if Pl.real && Pl.simulation==0 %&& Pl.willToExchange
                 Pl.Ptb.informPartnersAnswer(Pl.partnersType,Pl.proposedGood,will,Pl.willToExchange);
             end
             if ~Pl.willToExchange; return; end;
              %if this.real
         end
         
         function Pl=setMyBehavior(Pl,Proportion)
             if ~isstruct(Proportion)
                 return;
             end
             beta = Pl.discountFactor; 
             u=Pl.utility;
             d=Pl.productionCost;
             if ~Pl.perishable && Pl.productionCost==0
                 if strcmp(Pl.type,'cyan')
                         if Pl.cost('magenta')-Pl.cost('yellow')>=(Proportion.pMagenta.gCyan-Proportion.pYellow.gCyan)*((u*beta)/3)
                             Pl.optimalBehavior='fundamental';
                         else
                             Pl.optimalBehavior='speculative';
                         end
                 else
                     return;
                 end
             end
             if Pl.perishable && Pl.noStockCost
                 if (Proportion.pMagenta.gCyan-Proportion.pYellow.gCyan)*(u-d)>2*d
                     Pl.optimalBehavior='speculative';
                 else
                     Pl.optimalBehavior='fundamental';
                 end
             end
             if (Pl.perishable && ~Pl.noStockCost) || (Pl.productionCost>0 && ~Pl.perishable)
             % Throw an error.
                err = MException('Player:WrongParameters', ...
                            ['The Player class is not configured for theese settings : Player.perishable = ' Pl.perishable ', Player.noStockCost = ' Pl.noStockCost ', Player.perishable = ' Pl.perishable '.']);
                throw(err)
             end
             
            
         end
         
         function [ugood good]=myTypeGood(Pl)
             good=Pl.type;
             ugood=good; ugood(1)=upper(ugood(1));
         end

    end
    
    methods (Static)
        function c = cost(good)
            %cost(good) - Player's cost for the good 
            %good can be name or number
            if Player.noStockCost; c=0; return; end;
            switch good
                case {'cyan', 1}
                    c=1;
                case {'yellow', 2}
                    c=4;
                case {'magenta', 'cmagenta', 3, 4}
                    c=9;
            end
        end
        
        function [good ugood]=goodProduced(type)
            switch(type)
                case 'cyan'
                    good='yellow';
                case 'yellow'
                    good='magenta';
                case 'magenta'
                    good='cyan';
                otherwise
                    good='nothing';
            end
            ugood=good; ugood(1)=upper(ugood(1));
        end
                
        function [nsub compname]=getRealNumber()
            address=java.net.InetAddress.getLocalHost;
            IPaddress=char(address.getHostAddress);
            compname=char(address.getHostName);
            ipstring=regexp(IPaddress,'\.','split');
            nsub=str2double(ipstring{4});
            % if nsub==101; nsub=1; end;
            if nsub<1 || nsub>20; nsub=1; end;
            if str2double(ipstring{1})~=192; nsub=1; end;
         end
    end
    
end

