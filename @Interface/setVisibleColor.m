function  image=setVisibleColor(this,image,color)
            %setVisibleColor(cadre,color) sets visible color =color
            %
            s=size(image);
            for i=1:s(1)
                for j=1:s(2)
                    if(image(i,j,4)>0)
                        image(i,j,1:3)=color;
                    end
                end
            end
end