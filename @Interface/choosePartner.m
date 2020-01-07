function pType = choosePartner(this)
    this.resetScreen;
    Screen('Close', this.window);
    ptypes = '';
    for i = 1:length(Player.possibleTypes);
        if i > 1;
            ptypes = strcat(ptypes, ',');
        end;
        ptypes = strcat(ptypes, Player.possibleTypes{i});
    end;
    for h = 1:50;
        display('Veuillez patienter...');
        display(' ');
    end;
    [status, pType] = dos(['questionnaire.exe blocname:ChoosePartner', ' types:', ptypes]);
    %display(pType);
    this.initializeWindow;
    this.resetScreen;
end
