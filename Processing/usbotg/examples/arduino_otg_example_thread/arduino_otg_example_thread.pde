import android.util.Log;

void setup()
{
  orientation(PORTRAIT);
  et_begin();
  textSize(40);
}

int oldvalue = 0;
int pos = 0;
void draw()
{
  if (mousePressed)
  {
    background(0);
  }

  background(0,0,0);
  text(buffer.size(), 200,300);
  text(data.value, 200, 200);

  // Easytransfer

  while (et_receive())
  {
    data.param=1;

    et_send(data);

    //debug("param:" + data.param);
    //debug("value:" + data.value);

    if (oldvalue+1 != data.value)
    {
      Log.v("illutron", "value=" + data.value);
    } else
    {
    }
    oldvalue = data.value;
    noStroke();


    ellipse(((pos++))%displayWidth, data.value+500, 2, 2);
  }

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

