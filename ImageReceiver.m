%fclose(instrfind);

s = serial('com3');
set(s,'BaudRate',1000000);
set(s,'InputBufferSize',752*480);
set(s,'Timeout',30);
fopen(s);

while 1
    fwrite(s,'X');
    m = fread(s,[752,480]);
    m_real=(m/256)';
    m_real=m_real(480:-1:1,752:-1:1);
    red=m_real(1:2:480,1:2:752);
    blue=m_real(2:2:480,2:2:752);
    green=(m_real(1:2:480,2:2:752)+m_real(1:2:480,2:2:752))/2;
    pic=zeros(240,376,3);
    pic(:,:,1)=red;
    pic(:,:,2)=green;
    pic(:,:,3)=blue;
    imshow(pic);
    drawnow;
    pause(0.1);
end

fclose(s);
