import struct
import numpy as np
import time
import pickle
import h5py
from sklearn.decomposition import PCA

def read_train():
    #f = open("/home/xiaoweiw/research/video/profiling/vfe-c3d/C3D/examples/c3d_feature_extraction/output/videodb/pack/000001.fc7-1","rb")
    #f = open("000001.fc7-1","rb")
    #s = struct.unpack("i"*5,f.read(4*5))
    #print s
    #m = s[0]*s[1]*s[2]*s[3]*s[4]
    #tple = struct.unpack("f"*m, f.read(4*m))
    #print tple
    #f.close()
    nsamples = 550
    samples = np.zeros((nsamples,4096))
    nbaseball = 280
    nwrest = 270
    for i in range(nbaseball):
        start = i*16+1
        f = open("/home/xiaoweiw/research/video/profiling/vfe-c3d/C3D/examples/c3d_feature_extraction/output/videodb/baseball/"+str(start)+".fc7-1","rb")
        #f = open("/home/xiaoweiw/research/video/profiling/vfe-c3d/C3D/examples/c3d_feature_extraction/output/videodb/pack/"+format(start,"06")+".fc7-1","rb")
        s = struct.unpack("i"*5,f.read(4*5))
        #print s
        m = s[0]*s[1]*s[2]*s[3]*s[4]
        tple = struct.unpack("f"*m, f.read(4*m))
        f.close()
        
        darray = np.array(tple, dtype=np.float32)
        darray = darray.reshape(1,-1)
        samples[i,:] = darray
        #print darray.shape
    
    for i in range(nwrest):
        start = i*16+1
        f = open("/home/xiaoweiw/research/video/profiling/vfe-c3d/C3D/examples/c3d_feature_extraction/output/videodb/wrest/"+str(start)+".fc7-1","rb")
        s = struct.unpack("i"*5,f.read(4*5))
        m = s[0]*s[1]*s[2]*s[3]*s[4]
        tple = struct.unpack("f"*m, f.read(4*m))
        f.close()
        
        darray = np.array(tple, dtype=np.float32)
        darray = darray.reshape(1,-1)
        samples[i+nbaseball,:] = darray
    
    return samples

def read_test(ntest):
    ntest = 1500
    testdata = np.zeros((ntest,4096))
    for i in range(ntest):
        start = i+1
        #start = i*16+1
        f = open("/home/xiaoweiw/research/video/profiling/vfe-c3d/C3D/examples/c3d_feature_extraction/output/videodb/pack/"+str(start)+".fc7-1","rb")
        s = struct.unpack("i"*5,f.read(4*5))
        #print s
        m = s[0]*s[1]*s[2]*s[3]*s[4]
        tple = struct.unpack("f"*m, f.read(4*m))
        f.close()
        
        darray = np.array(tple, dtype=np.float32)
        darray = darray.reshape(1,-1)
        testdata[i,:] = darray
        #print darray.shape
    
    print testdata
    return testdata

def pca_train(data, ncomp):
    """
    Train PCA using samples 
    (# samples larger than # target dimensions) 
    """
    #ncomp = 3
    tpca = PCA(n_components=ncomp)
    #tpca = PCA(n_components=nsamples)
    #data = data.reshape(-1,1)
    tpca.fit(data)
    pickle.dump(tpca, open("pca_model.pkl","wb"))
    return tpca

def pca_project(data):
    """
    Use trained PCA to reduce dimension of input features 
    """
    #start = time.time()
    #time.sleep(1)
    tpca = pickle.load( open( "pca_model.pkl", "rb" ) )
    rdc = tpca.transform(data) # reduced features
    #end = time.time()
    #print (end - start)
    print rdc.shape
    print rdc
    return rdc
    
def createf5(c3d_ary):
    with h5py.File('videodb_c3d.h5', 'w') as hf:
        gp = hf.create_group("pack")
        ##print c3d_ary
        gp.create_dataset("c3d_features", data = c3d_ary)

def main():
    ntest = 4
    #train_data = read_train()
    #tpca = pca_train(train_data, 500)
    test_data = read_test(ntest)
    c3d_ary = pca_project(test_data)
    createf5(c3d_ary)



###
main()
