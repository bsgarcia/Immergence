function partialResetScreen(this)
            Screen('FillRect',this.window,this.white,[0 0 RectWidth(this.rect) RectHeight(this.rect)*0.37]);
            Screen('FillRect',this.window,this.white,[0 RectHeight(this.rect)*0.63 RectWidth(this.rect) RectHeight(this.rect)]);
            Screen('Flip',this.window);
end