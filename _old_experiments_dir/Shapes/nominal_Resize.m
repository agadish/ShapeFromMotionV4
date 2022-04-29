name = 'butterfly.png';
B=imread(name);
B=imresize(B,[300 335]);
C=imread(name);
imshowpair(B,C,'montage')
imwrite(B,name);