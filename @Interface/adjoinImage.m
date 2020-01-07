function imageRect = adjoinImage(this, rect, image)
    if find(strcmp([this.possibleColors], image))
        ball = 1;
        imageColor = this.findColor(image);
    else
        ball = 0;
        command = ['image=this.Images.', image, ';'];
        eval(command);
    end
    offsetHor = 0.3;
    offsetVert = -0.2;
    imageWidth = RectHeight(rect) * 2;
    imageRect = [0, 0, imageWidth, imageWidth];
    imageRect = CenterRect(imageRect, rect);
    imageRect = AdjoinRect(imageRect, rect, RectRight);
    imageRect = OffsetRect(imageRect, imageWidth*offsetHor, imageWidth*offsetVert);
    if ball
        Screen('FillArc', this.window, imageColor, imageRect, 0, 360);
    else
        Screen('DrawTexture', this.window, image, [], imageRect);
    end
    %imageRect=OffsetRect(imageRect,0,-imageWidth*offsetVert);
end