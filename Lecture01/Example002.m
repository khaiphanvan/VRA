function Example002()
    strMessage='\nNhap m:';
    m=input(strMessage);
    strMessage='\nNhap n:';
    n=input(strMessage);
    a=ones(m,n);
    b=zeros(m,n);
    c=eye(m,n);
    d=randi([-10,10],m,n);
    a(1,1)=5;
    e=size(a);
end

