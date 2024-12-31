function Img11=removeblackB(Img1)
%Img1=rightside2;
[ro,co,~]=size(Img1);
Img2=rgb2gray(Img1);
for i=1:ro
   % if(any(Img2(i,:))==1)
    if(sum(Img2(i,:))>5000)
        a=i;
        break;
    end
end
for i=0:ro
    %if(any(Img2(end-i,:))==1)
    if(sum(Img2(end-i,:))>5000)
        b=ro-i;
        break;
    end
end
for i=1:co
    %if(any(Img2(:,i))==1)
    if(sum(Img2(:,i))>5000)
        c=i;
        break;
    end
end
for i=0:co
    %if(any(Img2(:,end-i)==1))
     if(sum(Img2(:,end-i))>5000)   
        d=co-i;
        break;
    end
end
Img11=Img1(a:b,c:d,:);
