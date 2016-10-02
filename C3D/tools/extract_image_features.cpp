/*
 *
 *  Copyright (c) 2015, Facebook, Inc. All rights reserved.
 *
 *  Licensed under the Creative Commons Attribution-NonCommercial 3.0
 *  License (the "License"). You may obtain a copy of the License at
 *  https://creativecommons.org/licenses/by-nc/3.0/.
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 *  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 *  License for the specific language governing permissions and limitations
 *  under the License.
 *
 *
 */

#include <stdio.h>  // for snprintf
#include <cuda_runtime.h>
#include <google/protobuf/text_format.h>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <sys/time.h>

#include "caffe/blob.hpp"
#include "caffe/common.hpp"
#include "caffe/net.hpp"
#include "caffe/vision_layers.hpp"
#include "caffe/proto/caffe.pb.h"
#include "caffe/util/io.hpp"
#include "caffe/util/image_io.hpp"

using namespace caffe;  // NOLINT(build/namespaces)

template<typename Dtype>
int feature_extraction_pipeline(int argc, char** argv);

int main(int argc, char** argv) {
  return feature_extraction_pipeline<float>(argc, argv);
}

template<typename Dtype>
int feature_extraction_pipeline(int argc, char** argv) {
  char* net_proto = argv[1];
  char* pretrained_model = argv[2];
  int device_id = atoi(argv[3]);
  uint batch_size = atoi(argv[4]);
  uint num_mini_batches = atoi(argv[5]);
  char* fn_feat = argv[6];

  LOG(ERROR) << "batch size:" << batch_size;
  LOG(ERROR) << "num mini batches:" << num_mini_batches;

  Caffe::set_phase(Caffe::TEST);
  if (device_id>=0){
	  Caffe::set_mode(Caffe::GPU);
	  Caffe::SetDevice(device_id);
	  LOG(ERROR) << "Using GPU #" << device_id;
  }
  else{
	  Caffe::set_mode(Caffe::CPU);
	  LOG(ERROR) << "Using CPU";
  }

  shared_ptr<Net<Dtype> > feature_extraction_net(
      new Net<Dtype>(string(net_proto)));
  feature_extraction_net->CopyTrainedLayersFrom(string(pretrained_model));

  for (int i=7; i<argc; i++){
  CHECK(feature_extraction_net->has_blob(string(argv[i])))
      << "Unknown feature blob name " << string(argv[i])
      << " in the network " << string(net_proto);
  }
   /* 
    struct timeval start, end;
    gettimeofday(&start, NULL);
    */

  LOG(ERROR)<< "Extracting features for " << num_mini_batches << " batches";
  std::ifstream infile(fn_feat);
  string feat_prefix;
  std::vector<string> list_prefix;
  int c = 0;

  vector<Blob<float>*> input_vec;
  int image_index = 0;
  double total_elapsed = 0;
  for (int batch_index = 0; batch_index < num_mini_batches; ++batch_index) {
    
    struct timeval start, end;
    gettimeofday(&start, NULL);
    
    
    feature_extraction_net->Forward(input_vec);
    
    gettimeofday(&end, NULL);
    double elapsed = ((end.tv_sec * 1000000 + end.tv_usec) - (start.tv_sec * 1000000 + start.tv_usec))/1000000.0;
    total_elapsed += elapsed;
    
    list_prefix.clear();
    for (int n=0; n<batch_size; n++){
    	if (infile >> feat_prefix)
    		list_prefix.push_back(feat_prefix);
    	else
    		break;
    }

    if (list_prefix.empty())
    	break;
    for (int k=7; k<argc; k++){
    	const shared_ptr<Blob<Dtype> > feature_blob = feature_extraction_net
        ->blob_by_name(string(argv[k]));
    	int num_features = feature_blob->num();

    	Dtype* feature_blob_data;
        for (int n = 0; n < num_features; ++n) {
          if (list_prefix.size()>n){
        	  string fn_feat = list_prefix[n] + string(".") + string(argv[k]);
            //std::cout << fn_feat<< std::endl;
            //cout << feature_blob.get()
            save_blob_to_binary(feature_blob.get(), fn_feat, n);
          }
        }
    }
    image_index += list_prefix.size();
    if (batch_index % 100 == 0) {
        LOG(ERROR)<< "Extracted features of " << image_index <<
            " images.";
    }
  }
   
  /* 
    gettimeofday(&end, NULL);
    double elapsed = ((end.tv_sec * 1000000 + end.tv_usec) - (start.tv_sec * 1000000 + start.tv_usec))/1000.0;
    LOG(ERROR) << "Timer: " << elapsed;
    */
  
  LOG(ERROR)<< "Successfully extracted " << image_index << " features!";

  LOG(ERROR) << "Total time: " << total_elapsed;
  infile.close();

  // write elapsed time to the time log
  std::ofstream ft;
  ft.open ("timelog");
  ft << total_elapsed << std::endl;
  //ft << "Writing this to a file.\n";
  ft.close();
  return 0;
}


