/********************************************************************* *\
 * INTEL CORPORATION PROPRIETARY INFORMATION                            
 * This software is supplied under the terms of a license agreement or  
 * nondisclosure agreement with Intel Corporation and may not be copied 
 * or disclosed except in accordance with the terms of that agreement.  
 * Copyright (C) 2014 Intel Corporation. All Rights Reserved.           
 ********************************************************************* */

#include "Geometry.ih"

export void Geometry_setMaterial(void *uniform _geo, void *uniform _mat)
{
  uniform Geometry *uniform geo = (uniform Geometry *uniform)_geo;
  geo->material = (uniform Material *uniform)_mat;
}

//! constructor for ispc-side Geometry object
static void Geometry_Constructor(uniform Geometry *uniform geometry,
                                 void *uniform cppEquivalent,
                                 uniform Geometry_postIntersectFct postIntersect,
                                 uniform Model *uniform model,
                                 uniform int32  geomID,
                                 uniform Material *uniform material
                                 )
{
  geometry->cppEquivalent = cppEquivalent;
  geometry->model    = model;
  geometry->material = material;
  geometry->geomID   = geomID;
  geometry->postIntersect = postIntersect;
}

//! destructor for ispc-side Geometry object
extern void Geometry_Destructor(uniform Geometry *uniform mesh)
{
}