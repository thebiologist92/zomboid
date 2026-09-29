xof 0303txt 0032
template ColorRGBA {
 <35ff44e0-6c7c-11cf-8f52-0040333594a3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <d3e16e81-7835-11cf-8f52-0040333594a3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template Material {
 <3d82ab4d-62da-11cf-ab39-0020af71e433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template TextureFilename {
 <a42790e1-7810-11cf-8f52-0040333594a3>
 STRING filename;
}

template Frame {
 <3d82ab46-62da-11cf-ab39-0020af71e433>
 [...]
}

template Matrix4x4 {
 <f6f23f45-7686-11cf-8f52-0040333594a3>
 array FLOAT matrix[16];
}

template FrameTransformMatrix {
 <f6f23f41-7686-11cf-8f52-0040333594a3>
 Matrix4x4 frameMatrix;
}

template Vector {
 <3d82ab5e-62da-11cf-ab39-0020af71e433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template MeshFace {
 <3d82ab5f-62da-11cf-ab39-0020af71e433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template Mesh {
 <3d82ab44-62da-11cf-ab39-0020af71e433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

template MeshNormals {
 <f6f23f43-7686-11cf-8f52-0040333594a3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template MeshMaterialList {
 <f6f23f42-7686-11cf-8f52-0040333594a3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material <3d82ab4d-62da-11cf-ab39-0020af71e433>]
}

template Coords2d {
 <f6f23f44-7686-11cf-8f52-0040333594a3>
 FLOAT u;
 FLOAT v;
}

template MeshTextureCoords {
 <f6f23f40-7686-11cf-8f52-0040333594a3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}


Material Material__6 {
 1.000000;1.000000;1.000000;1.000000;;
 100.000000;
 0.200000;0.200000;0.200000;;
 0.000000;0.000000;0.000000;;

 TextureFilename {
  "Brass_Nameplate.png";
 }
}

Frame Brass_Nameplate_Hand {
 

 FrameTransformMatrix {
  1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000,0.000000,0.000000,0.000000,0.000000,1.000000;;
 }

 Mesh Brass_Nameplate_Hand {
  18;
  -0.005734;-0.021800;-0.018171;,
  -0.005734;0.231397;0.012448;,
  -0.005734;0.231397;-0.018171;,
  -0.005734;-0.021800;0.012448;,
  -0.005734;-0.021800;-0.018171;,
  0.019659;-0.021800;-0.006071;,
  -0.005734;-0.021800;0.012448;,
  -0.005734;-0.021800;0.012448;,
  0.019659;0.231397;-0.006071;,
  -0.005734;0.231397;0.012448;,
  0.019659;-0.021800;-0.006071;,
  -0.005734;0.231397;0.012448;,
  0.019659;0.231397;-0.006071;,
  -0.005734;0.231397;-0.018171;,
  -0.005734;0.231397;-0.018171;,
  0.019659;-0.021800;-0.006071;,
  -0.005734;-0.021800;-0.018171;,
  0.019659;0.231397;-0.006071;;
  8;
  3;0,1,2;,
  3;1,0,3;,
  3;4,5,6;,
  3;7,8,9;,
  3;8,7,10;,
  3;11,12,13;,
  3;14,15,16;,
  3;15,14,17;;

  MeshNormals {
   18;
   -1.000000;0.000000;0.000000;,
   -1.000000;0.000000;0.000000;,
   -1.000000;0.000000;0.000000;,
   -1.000000;0.000000;0.000000;,
   0.000000;-1.000000;0.000000;,
   0.000000;-1.000000;0.000000;,
   0.000000;-1.000000;0.000000;,
   0.589254;0.000000;0.807948;,
   0.589240;0.000000;0.807958;,
   0.589254;0.000000;0.807948;,
   0.589234;0.000000;0.807962;,
   0.000000;1.000000;0.000000;,
   0.000000;1.000000;0.000000;,
   0.000000;1.000000;0.000000;,
   0.430156;0.000000;-0.902754;,
   0.430152;0.000000;-0.902756;,
   0.430156;0.000000;-0.902754;,
   0.430152;0.000000;-0.902756;;
   8;
   3;0,1,2;,
   3;1,0,3;,
   3;4,5,6;,
   3;7,8,9;,
   3;8,7,10;,
   3;11,12,13;,
   3;14,15,16;,
   3;15,14,17;;
  }

  MeshMaterialList {
   1;
   8;
   0,
   0,
   0,
   0,
   0,
   0,
   0,
   0;
   { Material__6 }
  }

  MeshTextureCoords c1 {
   18;
   0.318668;0.968516;,
   0.021090;0.023241;,
   0.318668;0.023241;,
   0.021090;0.968516;,
   0.315573;0.604554;,
   0.011957;0.461432;,
   0.315573;0.242365;,
   0.634391;0.968474;,
   0.337035;0.023199;,
   0.634391;0.023199;,
   0.337035;0.968474;,
   0.313526;0.242364;,
   0.014694;0.464325;,
   0.313526;0.609337;,
   0.318285;0.968474;,
   0.020929;0.023199;,
   0.318285;0.023199;,
   0.020929;0.968474;;
  }
 }
}