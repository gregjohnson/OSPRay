%{

  /*
// ======================================================================== //
// Copyright 2009-2014 Intel Corporation                                    //
//                                                                          //
// Licensed under the Apache License, Version 2.0 (the "License");          //
// you may not use this file except in compliance with the License.         //
// You may obtain a copy of the License at                                  //
//                                                                          //
//     http://www.apache.org/licenses/LICENSE-2.0                           //
//                                                                          //
// Unless required by applicable law or agreed to in writing, software      //
// distributed under the License is distributed on an "AS IS" BASIS,        //
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. //
// See the License for the specific language governing permissions and      //
// limitations under the License.                                           //
// ======================================================================== //
*/ 
#define YY_MAIN 1
#define YY_NEVER_INTERACTIVE 0

#include "Loc.h"
#include "Model.h"
#include "parser_y.hpp" // (iw) use auto-generated one, not checked-in one
#include <string>

static void lCComment();
static void lCppComment();
static void lHandleCppHash();

 using namespace ospray;
 using namespace ospray::tachyon;

%}

%option nounput
%option noyywrap

WHITESPACE [ \t\r]+
INT_NUMBER (([0-9]+)|(0x[0-9a-fA-F]+))
FLOAT_NUMBER (([0-9]+|(([0-9]+\.[0-9]*f?)|(\.[0-9]+)))([eE][-+]?[0-9]+)?f?)|([-]?0x[01]\.?[0-9a-fA-F]+p[-+]?[0-9]+f?)

IDENT [a-zA-Z_][a-zA-Z_0-9\-]*

%%
Texture				  { return TOKEN_Texture;}
Shader_Mode     { return TOKEN_SHADER_MODE; }
Begin_Scene     { return TOKEN_BEGIN_SCENE; }
End_Scene       { return TOKEN_END_SCENE; }
Resolution      { return TOKEN_RESOLUTION; }
End_Shader_Mode { return TOKEN_END_SHADER_MODE; }
Trans_VMD       { return TOKEN_TRANS_VMD; }
Fog_VMD         { return TOKEN_FOG_VMD; }
Camera          { return TOKEN_Camera ; }
End_Camera      { return TOKEN_End_Camera ; }
Projection      { return TOKEN_Projection ; }
Orthographic    { return TOKEN_Orthographic ; }
Zoom            { return TOKEN_Zoom ; }
Aspectratio     { return TOKEN_Aspectratio ; }
Antialiasing    { return TOKEN_Antialiasing ; }
Raydepth        { return TOKEN_Raydepth ; }
Center          { return TOKEN_Center ; }
Viewdir         { return TOKEN_Viewdir ; }
Updir           { return TOKEN_Updir ; }
End_Camera      { return TOKEN_End_Camera; }
Directional_Light { return TOKEN_Directional_Light ; }
Direction       { return TOKEN_Direction ; }
Color           { return TOKEN_Color; }
Background      { return TOKEN_Background; }
Density         { return TOKEN_Density ; }
End             { return TOKEN_End ; }
Start           { return TOKEN_Start ; }
Fog             { return TOKEN_Fog ; }
Exp2            { return TOKEN_Exp2 ; }
FCylinder            { return TOKEN_FCylinder ; }
Base            { return TOKEN_Base ; }
Apex            { return TOKEN_Apex ; }
Rad             { return TOKEN_Rad ; }
Texture         { return TOKEN_Texture;}
Ambient         { return TOKEN_Ambient ;}
Diffuse         { return TOKEN_Diffuse ;}
Specular        { return TOKEN_Specular ;}
Opacity         { return TOKEN_Opacity;}
Phong           { return TOKEN_Phong ;}
Plastic         { return TOKEN_Plastic ;}
Phong_size      { return TOKEN_Phong_size ;}
TexFunc         { return TOKEN_TexFunc;}
STri            { return TOKEN_STri; }
N0              { return TOKEN_N0; }
N1              { return TOKEN_N1; }
N2              { return TOKEN_N2; }
V0              { return TOKEN_V0; }
V1              { return TOKEN_V1; }
V2              { return TOKEN_V2; }
Center          { return TOKEN_Center; }
Sphere          { return TOKEN_Sphere; }
VertexArray     { return TOKEN_VertexArray; }
End_VertexArray { return TOKEN_End_VertexArray; }
Numverts        { return TOKEN_Numverts; }
Colors          { return TOKEN_Colors;}
Coords          { return TOKEN_Coords;}
Normals         { return TOKEN_Normals;}
TriStrip        { return TOKEN_TriStrip; }
TriMesh         { return TOKEN_TriMesh; }
Ambient_Occlusion { return TOKEN_Ambient_Occlusion; }
Ambient_Color     { return TOKEN_Ambient_Color; }
Rescale_Direct    { return TOKEN_Rescale_Direct; }
Samples           { return TOKEN_Samples; }
Background_Gradient          { return TOKEN_Background_Gradient; }
UpDir             { return TOKEN_UpDir; }
TopVal            { return TOKEN_TopVal; }
BottomVal         { return TOKEN_BottomVal; }
TopColor          { return TOKEN_TopColor; }
BottomColor       { return TOKEN_BottomColor; }
TransMode         { return TOKEN_TransMode; }
R3D               { return TOKEN_R3D; }
Light             { return TOKEN_Light ; }
Attenuation       { return TOKEN_Attenuation; } 
linear            { return TOKEN_linear ; }
quadratic         { return TOKEN_quadratic ; }
constant          { return TOKEN_constant; }
Start_ClipGroup   { return TOKEN_Start_ClipGroup; }
End_ClipGroup     { return TOKEN_End_ClipGroup; }
NumPlanes         { return TOKEN_NumPlanes; }

{IDENT} { 
  yylval.identifierVal = strdup(yytext);
  return TOKEN_IDENTIFIER; 
}

{INT_NUMBER} { 
    char *endPtr = NULL;
    unsigned long long val = strtoull(yytext, &endPtr, 0);
    yylval.intVal = (int32_t)val;
    if (val != (unsigned int)yylval.intVal)
        Warning(Loc::current, "32-bit integer has insufficient bits to represent value %s (%llx %llx)",
                yytext, yylval.intVal, (unsigned long long)val);
    return TOKEN_INT_CONSTANT; 
}
-{INT_NUMBER} { 
    char *endPtr = NULL;
    unsigned long long val = strtoull(yytext, &endPtr, 0);
    yylval.intVal = (int32_t)val;
    return TOKEN_INT_CONSTANT; 
}

\".*\"				{ return TOKEN_OTHER_STRING; }



{FLOAT_NUMBER} { yylval.floatVal = atof(yytext); return TOKEN_FLOAT_CONSTANT; }
-{FLOAT_NUMBER} { yylval.floatVal = atof(yytext); return TOKEN_FLOAT_CONSTANT; }

"," { return ','; }
"{" { return '{'; }
"}" { return '}'; }
"[" { return '['; }
"]" { return ']'; }

{WHITESPACE} { /* nothing */ }
\n { Loc::current.line++; }

^#.*\n { 
  /*lHandleCppHash(); */ 
  Loc::current.line++;
   }

. { Error(Loc::current, "Illegal character: %c (0x%x)", yytext[0], int(yytext[0])); }

%%


// static void lHandleCppHash() {
//     char *src, prev = 0;

//     if (yytext[0] != '#' || yytext[1] != ' ') {
//         Error(Loc::current, "Malformed cpp file/line directive: %s\n", yytext);
//         exit(1);
//     }
//     Loc::current.line = strtol(&yytext[2], &src, 10) - 1;
//     if (src == &yytext[2] || src[0] != ' ' || src[1] != '"') {
//         Error(Loc::current, "Malformed cpp file/line directive: %s\n", yytext);
//         exit(1);
//     }
//     std::string filename;
//     for (src += 2; *src != '"' || prev == '\\'; ++src) {
//         filename.push_back(*src);
//     }
//     Loc::current.name = strdup(filename.c_str());
// }


