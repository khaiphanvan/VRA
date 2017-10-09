function saveNPrime(n)
 rArray = findNPrime(n);
 strFileName = ['prime',num2str(n),'.mat'];
 save(strFileName,'rArray');
end

