% Dictionary
num_gestures = 8;
Hash_prefix = HashTable(100);
Hash_prefix.Add('1',[Hash_LCS(num2str(11)),Hash_LCS(num2str(12)),Hash_LCS(num2str(14))]);
Hash_prefix.Add('2',[Hash_LCS(num2str(11)),Hash_LCS(num2str(12)),Hash_LCS(num2str(15))]);
Hash_prefix.Add('3',[Hash_LCS(num2str(11)),Hash_LCS(num2str(13)),Hash_LCS(num2str(16))]);
Hash_prefix.Add('4',[Hash_LCS(num2str(11)),Hash_LCS(num2str(13)),Hash_LCS(num2str(17))]);

Hash_prefix.Add('5',[Hash_LCS(num2str(21)),Hash_LCS(num2str(22)),Hash_LCS(num2str(24))]);
Hash_prefix.Add('6',[Hash_LCS(num2str(21)),Hash_LCS(num2str(22)),Hash_LCS(num2str(25))]);
Hash_prefix.Add('7',[Hash_LCS(num2str(21)),Hash_LCS(num2str(23)),Hash_LCS(num2str(26))]);
Hash_prefix.Add('8',[Hash_LCS(num2str(21)),Hash_LCS(num2str(23)),Hash_LCS(num2str(27))]);

for sem_num =1:2
	Hash_semantic_dictionary{sem_num} = HashTable(100);	
end

Hash_semantic_dictionary{1}.Add('0','Hands stretched');
Hash_semantic_dictionary{1}.Add('1','Waving');
Hash_semantic_dictionary{1}.Add('2','Pointing');
Hash_semantic_dictionary{1}.Add('3','Refusing');
Hash_semantic_dictionary{1}.Add('4','Explaining');
Hash_semantic_dictionary{1}.Add('5','Waving');
Hash_semantic_dictionary{1}.Add('6','Pointing');
Hash_semantic_dictionary{1}.Add('7','Refusing');
Hash_semantic_dictionary{1}.Add('8','Explaining');

Hash_semantic_dictionary{2}.Add('0','Two finger gesture ');
Hash_semantic_dictionary{2}.Add('1','Waving');
Hash_semantic_dictionary{2}.Add('2','Pointing');
Hash_semantic_dictionary{2}.Add('3','Refusing');
Hash_semantic_dictionary{2}.Add('4','Explaining');
Hash_semantic_dictionary{2}.Add('5','Waving');
Hash_semantic_dictionary{2}.Add('6','Pointing');
Hash_semantic_dictionary{2}.Add('7','Refusing');
Hash_semantic_dictionary{2}.Add('8','Explaining')
