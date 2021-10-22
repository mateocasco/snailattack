import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import TUIO.*;
import fisica.*;

Minim minim;
AudioPlayer sMusica;
AudioPlayer sPerdiste;
AudioPlayer sGanaste;
AudioSample chew;
AudioSample sonidoCajas;

FWorld mundo;
FCircle duende, caracol;
FMouseJoint cursor;
FBox piso;
FBox [] cajas = new FBox[2];
FBox duend;
FBox tope;
FDistanceJoint cadena;
Pendulo p;
TuioProcessing tuioClient;
float vidaArbol = 10;
Caracol[] caracoles = new Caracol[40];
FMouseJoint[] caracolesJoint = new FMouseJoint[40];
Float[] posEnY = new Float [40];
int identificacion;
int id = 0;

PImage fondo;
PImage imagen_caracol;
PImage imagen_duende;
PImage ganaste;
PImage perdiste;

int mil;
int seg = 0;
int min = 1;
boolean fiducial, agarro;

String estado = "";

float altura = 0;
float trans = 300;
int tiempo;
float sube[];
boolean musica = true;

float largoBarra = 330;
float valor = 33;
float f, x, y;
int cont = 0;

void setup() {
  size(520, 700);

  minim = new Minim( this );
  // sMusica = minim.loadFile("groove1.mp3", 2048);
  sPerdiste = minim.loadFile("smash.mp3", 2048);
  sGanaste = minim.loadFile("sparkles.mp3", 2048);
  chew = minim.loadSample("chew.mp3", 512);
  sonidoCajas = minim.loadSample("sonidocajas.mp3", 512);
  /*if (musica) {
   sMusica.loop();
   } else {
   sMusica.pause();
   }*/

  estado = "titulo";
  tiempo = 0;

  Fisica.init(this);
  mundo = new FWorld();
  p= new Pendulo();
  rectMode(CENTER);
  fondo = loadImage("bg.jpg");
  imagen_caracol = loadImage("caracolcolcol.png");
  imagen_duende = loadImage("spriteduende.png");
  ganaste = loadImage("ganaste.jpg");
  perdiste = loadImage("perdiste-01.jpg");

  for (int i = 0; i < caracoles.length; i++) {

    caracoles[i] = new Caracol(40, 60);
    //posEnY[i] = y;
  }

  mundo.setEdges();
  mundo.setGravity (0, 800);


  for (int i = 0; i < 80; i++ ) {
    sube= new float [80] ;
  }
  /*
  for (int i = 0; i < 2; i++ ) {
   cajas[i] = new FBox(70, 30);
   // cajas[i].setNoFill();
   // cajas[i].setNoStroke();
   cajas[i].setSensor(true);
   cajas[i].setName("caja_"+i);
   cajas[i].setStatic(true);
   
   mundo.add(cajas[i]);
   }
   
   
   cajas[0].setPosition(55, height-65);
   cajas[1].setPosition(width-55, height-65);
   */

  for (int i = 0; i < 2; i++ ) {
    cajas[i] = new FBox(70, 60);
    //cajas[i].setNoFill();
    cajas[i].setNoStroke();
    cajas[i].setSensor(true);
    cajas[i].setName("caja");
    cajas[i].setStatic(true);

    mundo.add(cajas[i]);
  }
  piso = new FBox(330, 20);
  piso.setPosition(width/2, 680);
  piso.setStatic(true);
  //piso.setNoFill();
  piso.setNoStroke();
  piso.setName("piso");

  mundo.add(piso);

  cajas[0].setPosition(55, height-65);
  cajas[1].setPosition(width-55, height-65);

  FBox borde = new FBox(width, 10);
  borde.setPosition(width/2, 0);
  borde.setNoFill();
  borde.setNoStroke();
  borde.setName("borde");
  borde.setStatic(true);
  borde.setGrabbable(false);
  mundo.add(borde);
  tuioClient  = new TuioProcessing(this);
}

void draw() {



  //Diagrama de estados//-----------------------

  if (estado.equals("inicio")) {
    fill(255, trans);
    trans = trans -3;
    image(fondo, 0, altura, width, height*2);
    rect(width/2, height/2, width, height);
    tiempo++;
    if (tiempo >120) {
      estado = "titulo";
      tiempo = 0;
    }
  } else if (estado.equals("titulo")) {
    image(fondo, 0, altura, width, height*2);
    altura= altura -3;
    tiempo++;
    if (tiempo >230) {
      estado = "gameplay";
      tiempo = 0;
    }
  } else if (estado.equals("gameplay")) {

    //musica = true;

    pushStyle();

    rectMode(CORNER);
    image(fondo, 0, altura, width, height*2);
    noStroke();
    fill(255, 90);
    rect(100, 25, 350, 30);
    if (vidaArbol >= 7) {
      fill(#FCFC82, 190);
      // fill(255, 0, 0);
    } else if (vidaArbol <=6 && vidaArbol >=3 ) {
      fill(#FCC682, 190);
    } else if (vidaArbol <= 2 ) {
      fill(#FC8C82, 190);
    }
    rect(110, 30, largoBarra, 20);

    popStyle();

    if (frameCount%300 == 0|| frameCount==2) {
      p.Dibujar();
    }

    /*
    if (frameCount % 300 == 0) {
     
     id++;
     
     for (int i=0; i<80; i++) {
     
     caracoles[i].inicializar (x, y);
     
     caracoles[i].attachImage(imagen_caracol);
     caracoles[i].setName("caracol"+i);
     
     caracolesJoint[i] = new FMouseJoint(caracoles[i], x, y );
     //caracolesJoint[id].setName ("cadena_"+id);
     
     posEnY[i]=y;
     }
     mundo.add(caracolesJoint[id]);
     }
     */

    if (frameCount % 300 == 0) {

      x = random( width/2 - 110, width/2 + 120);
      y = height - 60;
      id = id+1;

      caracoles[id].inicializar(x, y);
      caracoles[id].setName ("caracol_"+id);
      caracoles[id].attachImage(imagen_caracol);
      mundo.add(caracoles[id]);

      caracolesJoint[id] = new FMouseJoint(caracoles[id], x, y );
      //caracolesJoint[id].setName ("cadena_"+id);
      mundo.add(caracolesJoint[id]);

      posEnY[id] = y;
    }


    //
    /*
    if (frameCount%2==0) {
     
     sube[id] = sube[id] +0.5;
     }
     */


    for (int i=0; i<caracolesJoint.length; i++) {
      if (caracolesJoint[i] != null) {

        //FBox c = caracoles[i];
        float xc = caracoles[i].getX();
        // posEnY[i] = y;

        //f = posEnY[i] - sube[i];
        posEnY[i]--;                               // ACÁ SE SETEA LA VELOCIDAD DE SUBIDA DE CARACOLES

        //if (agarro == false) {

        caracolesJoint[i].setTarget(xc, posEnY[i] );

        /* if (agarro) {
         
         caracoles[i].setPosition(duend.getX(), duend.getY());
         mundo.remove(caracolesJoint[i]);
         }
         */
      }
     // println ("agarro" + agarro);
     // println ("fiducial"+ fiducial);
      //float f = posEnY[id];
      //f=f-sube[id];


      //FMouseJoint j = caracolesJoint[id];
      //caracolesJoint[id].setTarget(xc, yc);
      // caracolesJoint = (FMouseJoint[]) append(caracolesJoint, j);
    }





    //float f = posEnY[id];

    //  posEnY[id]++;

    // caracolesJoint[id].setTarget(caracoles[id].getX(), posEnY[id]);


    /*
    for (FBox c : caracoles ) {
     float xc = c.getX();
     float yc = c.getY();
     */
    /*
    if (pruebo==false) {
     //c.setPosition (xc, yc-1.5); //REBOTE
     //c.setPosition (xc, yc);
     }
     if (pruebo) {
     c.setPosition(duend.getX(), duend.getY());
     }
     */




    /*for (FMouseJoint j : caracolesJoint){
     float posY = (height - frameCount);
     j.setTarget(random(width), posY);
     }*/
    /*
    for (int i=0; i<caracolesJoint.size(); i++) {
     
     caracolesJoint.get(i);
     FBox c = caracoles.get(i);
     float xc = c.getX();
     //float posY = (height - frameCount); //ACÁ SE SETEA LA VELOCIDAD DE SUBIDA DE CARACOLES
     
     float f = posEnY.get(i);
     
     f=f-sube[i];
     
     
     
     FMouseJoint j = caracolesJoint.get(i);
     j.setTarget(xc, f);
     }
     */

    if ( min != 0 || seg != 0 ) {
      timer();
    } else {
      estado = "ganaste";
      tiempo = 0;
    }
    if (vidaArbol<=0) {
      estado = "perdiste";
      tiempo = 0;
    }
  } else if (estado.equals("ganaste")) {
    //Condicion de victoria
    sGanaste.play();
    mundo.remove(duend);
    //mundo.remove(cadena);
    pushStyle();
    image(ganaste, 0, 0, width, height);
    popStyle();
    tiempo++;
    if (tiempo >120) {
      estado = "gameplay";
      tiempo = 0;
      reiniciar();
    }
  } else if (estado.equals("perdiste")) {
    musica = false;
    sPerdiste.play();
    mundo.remove(duend);
    mundo.remove(cadena);

    pushStyle();
    image(perdiste, 0, 0, width, height);
    popStyle();

    tiempo++;
    if (tiempo >120) {
      estado = "gameplay";
      tiempo = 0;
      reiniciar();
    }
  }


  //  p.Accion();
  mundo.step();
  mundo.draw();

  //println(vidaArbol, p.largo, sosten);
}


void timer() {
  int tiempoAnterior = 0;
  int tiempo = millis()/1000;

  if (tiempoAnterior != tiempo) {
    if (mil <= 0) {

      if ( seg <= 0 ) {
        seg = 60;
        min --;
        mil = 60;
      } else {
        seg --;
        mil = 60;
      }

      tiempoAnterior = tiempo;
    } else {
      mil --;
      tiempoAnterior = tiempo;
    }
  }

  pushStyle();
  textSize(28);
  text(min + " : " + seg, 20, 50);
  popStyle();
}

String darNombre (FBody cuerpo ) {
  String nombre = "nada";

  if (cuerpo != null) {
    String esteNombre = cuerpo.getName();
    if (esteNombre != null) {
      nombre = esteNombre;
    }
  }

  return nombre;
}

void contactStarted(FContact datosColision) {
  FBody cuerpo1 = datosColision.getBody1();
  FBody cuerpo2 = datosColision.getBody2();

  if (agarro) {

    for (int i = 0; i<caracolesJoint.length; i++) {
      if (darNombre( cuerpo1 ).equals("caracol_"+i) && darNombre( cuerpo2 ).equals("duende")) {
        /*float dx, dy;
         dx = duend.getX();
         dy = duend.getY();
         cuerpo1.setPosition(dx,dy);
         */
        cuerpo1.setRotatable(true);
        mundo.remove(caracolesJoint[i]);
        /*FMouseJoint j = new FMouseJoint(cuerpo1, duend.getX(), duend.getY());
         j.setTarget(duend.getX(), duend.getY());*/
      }
      if (darNombre( cuerpo2 ).equals("caracol_"+i) && darNombre( cuerpo2 ).equals("duende")) {
        /*
        float dx, dy;
         dx = duend.getX();
         dy = duend.getY();
         
         cuerpo2.setPosition(dx,dy);
         */
        cuerpo2.setRotatable(true);
        mundo.remove(caracolesJoint[i]);
      }
    }
  }



  for (int i = 0; i<caracolesJoint.length; i++) {
    /*if (agarro) {
     
     if(darNombre( cuerpo1 ).equals("caracol_"+i)){
     cuerpo1.setPosition(duend.getX(), duend.getY());
     background(0);
     }
     if(darNombre( cuerpo2 ).equals("caracol_"+i)){
     background(0);
     cuerpo2.setPosition(duend.getX(), duend.getY());
     }
     }*/
  }

  for (int i=0; i<caracolesJoint.length; i++) {

    if ( darNombre( cuerpo1 ).equals("caja") && darNombre( cuerpo2 ).equals("caracol_"+i)
      || darNombre (cuerpo1).equals("caja") && darNombre (cuerpo2).equals("cBox"+i) ) {
      mundo.remove(cuerpo2);
      sonidoCajas.trigger();
    } else
      if (darNombre( cuerpo2 ).equals("caja") && darNombre( cuerpo1 ).equals("caracol_"+i)
        || darNombre (cuerpo2).equals("caja") && darNombre (cuerpo1).equals("cBox"+i) ) {
        mundo.remove(cuerpo1);
        sonidoCajas.trigger();
      }
  }

  for (int i=0; i<caracolesJoint.length; i++) {
    if ( darNombre (cuerpo1).equals("piso") && darNombre (cuerpo2).equals("caracol_"+i)) {
      mundo.remove(cuerpo2);
      //speed+=0.35;
      x = random( width/2 - 110, width/2 + 120);
      y = height - 120;
     // id = id+ 1;
     
      cont = cont +1;

      if (cont%2 == 0) {
        id = id+ 1;

        println("par");
      

      caracoles[id].inicializar(x, y);
      caracoles[id].setName ("caracol_"+id);
      caracoles[id].attachImage(imagen_caracol);
      mundo.add(caracoles[id]);

      caracolesJoint[id] = new FMouseJoint(caracoles[id], x, y );
      //caracolesJoint[id].setName ("cadena_"+id);
      mundo.add(caracolesJoint[id]);

      posEnY[id] = y;
      }
    } else
      if (darNombre( cuerpo2 ).equals("piso") && darNombre( cuerpo1 ).equals("caracol_"+i)) {
        mundo.remove(cuerpo1);
        // speed+=0.35;
        x = random( width/2 - 110, width/2 + 120);
        y = height - 120;
        //id = id+ 1;
        
        cont = cont +1;
        
        if (cont%2 == 0) {
          id = id+ 1;

          println("par");
        

        

        caracoles[id].inicializar(x, y);
        caracoles[id].setName ("caracol_"+id);
        caracoles[id].attachImage(imagen_caracol);
        mundo.add(caracoles[id]);

        caracolesJoint[id] = new FMouseJoint(caracoles[id], x, y );
        //caracolesJoint[id].setName ("cadena_"+id);
        mundo.add(caracolesJoint[id]);

        posEnY[id] = y;
        }
      }
  }

  for (int i=0; i<caracolesJoint.length; i++) {

    if ( darNombre( cuerpo1 ).equals("borde") &&
      darNombre( cuerpo2 ).equals("caracol_"+i) ) {
      mundo.remove(cuerpo2);
      vidaArbol= vidaArbol-1;
      chew.trigger();
      largoBarra = largoBarra - valor;

      //ACA SE PONE LA VIDA DEL ARBOL
    }
  }
  /*
    if (darNombre( cuerpo2 ).equals("borde") &&
   darNombre( cuerpo1 ).equals("caracol")) {
   mundo.remove(cuerpo1);
   
   
   //ACA SE PONE LA VIDA DEL ARBOL
   }
   */
  for (int i=0; i<caracolesJoint.length; i++) {


    if (darNombre( cuerpo1 ).equals("duende") &&
      darNombre( cuerpo2 ).equals("caracol_"+i) ||
      darNombre( cuerpo1 ).equals("caracol_"+i) &&
      darNombre( cuerpo2 ).equals("duende")) {

      agarro=true;
    }
  }
  //println(cuerpo1.getName());
  //  println(cuerpo2.getName());
}

void reiniciar() {
  vidaArbol = 10;
  seg = 0;
  min = 1;
  largoBarra = 330;
}


/*void caracolesSuben(){
 ArrayList<FBody> cuerpos = mundo.getBodies();
 
 for (FBody cuerpo : cuerpos){
 float dy =(yc - 800);
 cuerpo.addForce(0, dy *100);
 }*/

//-------------------------------------------
void addTuioObject(TuioObject objetoTuio) {
  //if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
  identificacion= objetoTuio.getSymbolID();
  //println(objetoTuio.getSymbolID());
}
//-------------------------------------------
void updateTuioObject (TuioObject objetoTuio) {
  //if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
  //        +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
  identificacion= objetoTuio.getSymbolID();
  //println(objetoTuio.getSymbolID());
  if (identificacion==7) {

    duend.setPosition(objetoTuio.getX()* width, duend.getY());
  }
  if (identificacion==8) {
    fiducial=true;
  }
}
//-------------------------------------------
void removeTuioObject(TuioObject objetoTuio) {
  //if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  identificacion= objetoTuio.getSymbolID();
  println(objetoTuio.getSymbolID());
  if (identificacion==8) {
    fiducial=false;
    agarro=false;

    for (int i=0; i<caracolesJoint.length; i++) {
      caracoles[i].setRotatable(true);
    }
  }
}
// --------------------------------------------------------------
void addTuioCursor(TuioCursor tcur) {
  //if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}
//-------------------------------------------
void updateTuioCursor (TuioCursor tcur) {
  //if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
  //        +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}
//-------------------------------------------
void removeTuioCursor(TuioCursor tcur) {
  //if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}
// --------------------------------------------------------------
void addTuioBlob(TuioBlob tblb) {
  //if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}
//-------------------------------------------
void updateTuioBlob (TuioBlob tblb) {
  //if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
  //        +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}
//-------------------------------------------
void removeTuioBlob(TuioBlob tblb) {
  //if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}
// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  //if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  //if (callback) redraw();
}
