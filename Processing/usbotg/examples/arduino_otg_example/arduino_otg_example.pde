import android.util.Log;

void setup()
{
  orientation(PORTRAIT);
  et_begin();
  textSize(40);
}


int pos = 0;
void draw()
{
  if (mousePressed)
  {
    background(0);
  }

  //  background(data.value,0,0);
  text(data.value, 200, 200);

  text(data.param, 200, 1000);
  // Easytransfer

  if (et_receive())
  {
    
     ellipse(((pos++))%displayWidth, data.value+500, 2, 2);
     
  


    noStroke();


   
  }
  /*
    data.param=2;
    data.value = mouseX;

    et_send(data);*/

  // BASIC SERIAL


  //int pos = 0;
  /* noStroke();
   //background(0, 255, 0);
   while (usb_avaliable () > 0)
   {
   byte value = (byte) usb_read();
   text("asd:" + value, 100, 220); 
   Log.v("illutron", "1value=" + value);
   ellipse(((pos++))%displayWidth, value+500, 2, 2);
   pos = pos + 1;
   }*/

  text(millis(), 100, 100);
}

void mouseMoved()
{
  /* et_send(data);
   data.value = (short)map((short)mouseX, 0, width, 0, 255);
   println(data.value);
   data.param = 1;*/
}

int debugPos = 0;

void debug(String _msg)
{
  //text(_msg, 100,((debugPos++)*30)%displayHeight);
}

