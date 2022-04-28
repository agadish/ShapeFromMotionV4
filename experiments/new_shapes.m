

a=imread('butterfly.png');

[I J K]=size(a);

for k=1:K
    for i=1:I
        for j=1:J
            if a(i,j,k)<100
                a(i,j,k)=0;
            else
                a(i,j,k)=255;
            end
        end
    end
end

imwrite(a,'new_butterfly.png');