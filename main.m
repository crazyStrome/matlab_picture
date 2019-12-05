function main

    srcDir=uigetdir('Choose source directory.'); %���ѡ����ļ���
    cd(srcDir);
    allnames = struct2cell(dir('*.jpg')); %����jpg�ļ�
    [~,len] = size(allnames); %���jpg�ļ��ĸ���
    color=[0;20;40;60;80;100;120;140;160;181;200;220;240;260;280;300;320;340];
    temp=zeros(size(imread(allnames{1,1})));

    wa=waitbar(0,'wait');
    for ii=1:len%���ȡ���ļ�
        
        %ÿһ��ѭ�����ļ���
        name = allnames{1,ii};
        disp(name);
        
        img=mat2gray(imread(name));  %��������ӳ�䵽[0,1];
        [m ,n,~]=size(img);
        

        
        
        %%ͼ���RGB
        R=img(:,:,1);
        G=img(:,:,2);
        B=img(:,:,3);

        %%ͼ��RGB2HSL
        H=zeros(m,n);   %ɫ���
        S=zeros(m,n);   %���Ͷ�
        L=zeros(m,n);   %����
        for i=1:m
            for j=1:n
                r=R(i,j);
                g=G(i,j);
                b=B(i,j);
                MAX=max([r,g,b]);
                MIN=min([r,g,b]);

                if MAX==MIN
                    H(i,j)=0;
                elseif MAX==r && g>=b
                    H(i,j)=60*(g-b)/(MAX-MIN);
                elseif MAX==r && g<b
                    H(i,j)=60*(g-b)/(MAX-MIN)+360;
                elseif MAX==g
                    H(i,j)=60*(b-r)/(MAX-MIN)+120;
                elseif MAX==b
                    H(i,j)=60*(r-g)/(MAX-MIN)+240;
                end

                L(i,j)=(MAX+MIN)/2;

                if L(i,j)==0 || MAX==MIN
                    S(i,j)=0;
                elseif 0<L(i,j) && L(i,j)<=0.5
                    S(i,j)=(MAX-MIN)/(2*L(i,j));
                elseif L(i,j)>0.5
                    S(i,j)=(MAX-MIN)/(2-2*L(i,j));
                end
                if H(i,j)>60 && H(i,j)<240
                    H(i,j)=color(ii,1);
                    %S(i,j) = S(i,j)/len;
                    %L(i,j) = L(i,j)/len;
                end
            end
        end

        
        
        %%ͼ��HSL2RGB
        for i=1:m
            for j=1:n
                s=S(i,j);   
                l=L(i,j);         
                if s~=0
                    h=H(i,j);      
                    if l<0.5
                        q=l*(1+s);
                    else
                        q=l+s-(l*s);
                    end
                    p=2*l-q;
                    hk=h/360;
                    tR=hk+1/3;
                    tG=hk;
                    tB=hk-1/3;
           
                    R(i,j)=foo(tR,p,q);
                    G(i,j)=foo(tG,p,q);
                    B(i,j)=foo(tB,p,q);
                else
                    R(i,j)=l;
                    G(i,j)=l;
                    B(i,j)=l;
                end
            end
            
        end
        
        
        
        
        %%��������任��û��Ļ�����ôͼ���ǲ����
        img(:,:,1)=R/11;
        img(:,:,2)=G/11;
        img(:,:,3)=B/11;
        %figure;
        %imshow(img)
        % I=['figure',num2str(ii),'.jpg'];%ͼƬ����
         %imwrite(img,I);%����ͼƬ
        temp=imadd(temp,img);%����
        waitbar(ii/len);
    end
    imwrite(temp,'result.bmp');
    imshow(temp);
    close(wa); 
end
    
    
    function re=foo(t,p,q)
        if t<0
            t=t+1.0;
        elseif t>1
            t=t-1.0;
        end
        
        if t<1/6
            re=p+((q-p)*6*t);
        elseif 1/6<=t && t<0.5
            re=q;
        elseif 0.5<=t && t<2/3
            re=p+((q-p)*6*(2/3-t));
        else
            re=p;
        end
    end    
