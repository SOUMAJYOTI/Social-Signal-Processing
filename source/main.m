% Social Signal Processing from hand images to predict human social behavior

% Written by Soumajyoti Sarkar as part of the 
% Final year BE project under Dr. Jaya Sil
% at Indian Institute of Engineering Science and Technology, Shibpur


clc
clear all

%Parameters for PHOG descriptor
bin = 8;
angle = 360;
L=3;

num_gest=2;          % number of gesture clusters
n=2;                 % number of getsure sets in each gesture cluster
cost = zeros(40,40); % cost tree for each gesture cluster
total=1;             % Keeps count of the total number of root gestures for SVM model

% Prepares the initial SVM model of the gesture clusters
for j=1:num_gest
	for k=1:n
		clear phog_desc;
		root_names = strcat('gesture_codebook/gesture_',int2str(j),'/',num2str(k),'.jpg');
		roi = [1;size(imread(root_names),1);1;size(imread(root_names),2)];
		phog_desc{:} = phog(root_names, bin, angle, L, roi);
		phog_global(total,:)= phog_desc{1};
		trainLabel(total)=j;
		total=total+1;
	end
end
trainLabel=trainLabel';
chiKernel = chi_square_kernel(phog_global,phog_global,4);
numTrain = size(trainLabel,1);
K =  [ (1:numTrain)' , chiKernel ];
SVM_model = svmtrain(trainLabel, K, '-t 4 -b 1');

% Classify the test root image into one of the gesture clusters
clear phog_desc;
image_dir = 'test_sequence/t_2/';
fnames = dir(fullfile(image_dir, '*.jpg'));
num_files = size(fnames,1);
name = fnames(1).name;
img_test = strcat(image_dir,name);
disp(img_test);
roi = [1;size(imread(img_test),1);1;size(imread(img_test),2)];
phog_desc{:} = phog(img_test, bin, angle, L, roi);
phog_test(1,:)=phog_desc{1};

testLabel = [1];
numTest = size(testLabel,1);
KTest = chi_square_kernel(phog_test,phog_global,4);
KK =  [ (1:numTest)' , KTest ];
[predTestLabel, acc, prob] = svmpredict(testLabel, KK, SVM_model, '-b 1'); %predTestLabel gives the gesture cluster to mine
g = predTestLabel;

%  Create training set in FOREST datastructure
for i=1:n
	image_dir = strcat('gesture_codebook/gesture_',int2str(g),'/gest_', num2str(i), '/');
	fnames = dir(fullfile(image_dir, '*.jpg'));
	num_files = size(fnames,1);
	root_img = dir(fullfile(image_dir, strcat(num2str(i),'1.jpg')) );
	root_name = strcat('gesture_codebook/gesture_',int2str(g),'/','gest_',num2str(i),'/', num2str(i),'1.jpg');
	roi = [1;size(imread(root_name),1);1;size(imread(root_name),2)];
	phog_desc{:} = phog(root_name, bin, angle, L, roi);
	s =struct('phog_desc', phog_desc, 'number', str2num(strcat(num2str(i),'1')));
	t(i)= tree(s);
         
	disp(image_dir);
	for j=2:num_files
		clear phog_desc;
		n2 = int2str(j); 
		n1 = int2str(i);			
		nameImg = strcat(image_dir,strcat(n1,n2,'.jpg'));
		%img = dir(fullfile(image_dir, nameImg));
		disp(nameImg)
		roi = [1;size(imread(nameImg),1);1;size(imread(nameImg),2)];
		phog_desc{:} = phog(nameImg, bin, angle, L, roi); 
		%k = k%10;
		k = j/2.0;
		k = floor( k );
		%disp(k);
		node_parent=cell2mat(t(i).Node(k));
		phog_parent=node_parent.phog_desc;
        	dist = chi_square_kernel(phog_desc{:}, phog_parent,4);
		%disp(dist);
		parent_num = str2num(strcat(int2str(i),int2str(k)));
		own_num = str2num(strcat(int2str(i),int2str(j)));
		cost(parent_num,own_num)=dist;
		s =struct('phog_desc', phog_desc, 'number', str2num(strcat(n1,n2)));
		[t(i) n1] = t(i).addnode(k, s);	
		%disp(n1);
	end	
	disp(t(i).tostring)
end

disp('After adding redundant gestures');
%{
nameImg = 'gesture_codebook/gest_3/37.jpg';
roi = [1;size(imread(nameImg),1);1;size(imread(nameImg),2)];
phog_desc{:} = phog(nameImg, bin, angle, L, roi); 
s =struct('gest_name','NULL','phog_desc', phog_desc, 'number', 37);
[t(1) n1] = t(1).addnode(2,s);
disp(t(1).tostring)
%}

H= HashTable(10);
H.Add('1',[2,3]);
H.Add('2',[4,5,6,7]);
H.Add('3',[4,5,6,7]);

for i=1:n
	for j=1:3
		vals = H.Get(int2str(j));
		node_orig=cell2mat(t(i).Node(j));
		phog_orig=node_orig.phog_desc;
		for k=1:n
			if k~=i
				for l=1:size(vals,2)
					node_contents=t(k).Node(vals(l));
					contents = cell2mat(node_contents);
					phog_desc_new = contents.phog_desc;
					dist = chi_square_kernel(phog_orig, phog_desc_new,4);
					%disp(i);disp(j);disp(k);disp(vals(l));
					%disp(dist)
					if(dist<400)
						n1=int2str(k);n2=int2str(vals(l));
						s=struct('phog_desc', {phog_desc_new}, 'number', str2num(strcat(n1,n2)));
						[t(i) n1] = t(i).addnode(j, s);	
						parent_num = str2num(strcat(int2str(i),int2str(j)));
						own_num = str2num(strcat(int2str(k),int2str(vals(l))));
						%disp(parent_num);disp(own_num);
						cost(parent_num,own_num)=dist;
					end
				end
			end
		end
	end
end	

for i=1:n
	fprintf('\nDisplaying Tree %d\n',i);
	disp(t(i).tostring)
end

Hash_LCS = HashTable(100);
Hash_LCS.Add('11','a');
Hash_LCS.Add('12','b');
Hash_LCS.Add('13','c');
Hash_LCS.Add('14','d');
Hash_LCS.Add('15','e');
Hash_LCS.Add('16','f');
Hash_LCS.Add('17','g');

Hash_LCS.Add('21','h');
Hash_LCS.Add('22','i');
Hash_LCS.Add('23','j');
Hash_LCS.Add('24','k');
Hash_LCS.Add('25','l');
Hash_LCS.Add('26','m');
Hash_LCS.Add('27','n');

Hash_LCS.Add('31','o');
Hash_LCS.Add('32','p');
Hash_LCS.Add('33','q');
Hash_LCS.Add('34','r');
Hash_LCS.Add('35','s');
Hash_LCS.Add('36','t');
Hash_LCS.Add('37','u');

% Generating the sequence of gestures from the gesture cluster (FOREST)
image_dir = 'test_sequence/t_2/';
fnames = dir(fullfile(image_dir, '*.jpg'));
num_files = size(fnames,1);
sequence_list=[];

for i=1:size(num_files)
	name = fnames(1).name;
	img_test = strcat(image_dir,name);
	roi = [1;size(imread(img_test),1);1;size(imread(img_test),2)];
	phog_desc{:} = phog(img_test, bin, angle, L, roi);
	phog_test(1,:)=phog_desc{1};

	clear phog_desc;
	for j=1:n
		node_contents=t(j).Node(1);
		contents = cell2mat(node_contents);
		phog_desc_new = contents.phog_desc;
		dist(j) = chi_square_kernel(phog_test, phog_desc_new,4);
	end
	[dist_min idx]= min(dist);
	tree_number = idx;

	sequence_list = [sequence_list Hash_LCS.Get((strcat(int2str(j),int2str(1))))];
	parent_num=1; % Initial parent is the root of the tree 

	for k=2:num_files
		clear phog_test;
		name = fnames(k).name;
		img_test = strcat(image_dir,name);
		roi = [1;size(imread(img_test),1);1;size(imread(img_test),2)];
		phog_desc{:} = phog(img_test, bin, angle, L, roi);
		phog_test(1,:)=phog_desc{1};
		
		count=1; % Keeps count of the node number in test sequence being operated on 
		cnt=1; % Index count
	
		new_parents=[];
		while 1    % Till all the test nodes are exhausted
			node_nums=t(tree_number).Parent;
			cnt=1;
			%disp(node_nums);
			for h=1:size(node_nums,1)
				if (node_nums(h) == parent_num) || (ismember(node_nums(h),new_parents)==1)
					%disp(h)			
					clear phog_desc_new;
					node_contents=t(tree_number).Node(h);
					contents = cell2mat(node_contents);
					phog_desc_new = contents.phog_desc;
					distn(cnt) = chi_square_kernel(phog_test, phog_desc_new,4);		
					id(cnt) = h;
					cnt = cnt+1;
					
				end
			end
			[dist_min idx] = min(distn);
			%disp(new_parents)
			% If minimum distance is less than 400 add the node to the sequence list
			if(dist_min<=400)
				%disp(id(idx));
				numb=cell2mat(t(tree_number).Node(id(idx)));
				sequence_list=[sequence_list Hash_LCS.Get(num2str(numb.number))];
				count=count+1;
				parent_num=id(idx);				
				break;
			else
				for p_list=1:size(node_nums,1)
					if node_nums(p_list)==parent_num
						new_parents = [new_parents p_list];
					end
				end
				parent_num = -1;
				disp(new_parents);
				
			end	
			clear distn,id;
		end				
	end 
end

Semantic_dictionary

fprintf('The encoded sequence list of the gestures are:  ')
disp(sequence_list)
for i=1:num_gestures
	[D, dist, aLongestString] = LCS(Hash_prefix(num2str(i)),sequence_list);
	if length(aLongestString)>=1
		fprintf('\nThe gesture recognized is:\n')
		fprintf('\n Of left hand')
		fprintf('The person has %s\n', Hash_semantic_dictionary{g}.Get(num2str('0')));
		fprintf('and the person is %s\n', Hash_semantic_dictionary{g}.Get(num2str(i)));
		break
	end
end

%{
% Test the test image sequence
image_dir = 'test_sequence/';
fnames = dir(fullfile(image_dir, '*.jpg'));
num_files = size(fnames,1);
parent = 1;

store(1) = 1;
for i=2:num_files
	img = strcat(image_dir,fnames(i).name);
	disp(img);
	pyramid_test = createPyramid(img);
	pyramid_train(1,:) = t.get(parent*2);
	pyramid_train(2,:) = t.get(parent*2+1);
	KTrain = hist_isect(pyramid_train,pyramid_train); 
	KTest = hist_isect(pyramid_test,pyramid_train); 
	trainLabel = [-1;1]; 
	numTrain = size(trainLabel,1);
	K =  [ (1:numTrain)' , KTrain ];
	SVM_model = libsvmtrain(trainLabel, K, '-t 4 -b 1');

	testLabel = [1];
	numTest = size(testLabel,1);
	KK =  [ (1:numTest)' , KTest ];
	[predTestLabel, acc, prob] = libsvmpredict(testLabel, KK, SVM_model, '-b 1'); 
	if prob(1) > prob(2)
		parent = parent*2;
	else
		parent = parent*2+1;
	end
	store(i) = parent;
end

fprintf('\n\nThe sequnece of gestures are:')
disp(store);

%}
