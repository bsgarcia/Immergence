function resetScreen(this)
    Screen('FillRect', this.window, this.white);
    Screen('Flip', this.window);
end