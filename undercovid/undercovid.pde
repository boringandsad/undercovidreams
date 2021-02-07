import java.util.Map;
HashMap<String,PVector> words;
HashMap<String,ArrayList<String>> dreams_to_words;
HashMap<String,PVector> dreams_to_coords;

float min_x=0;
float min_y=0;
float max_x=0;
float max_y=0;

// sample line
// [{"text": "praticamente questa notte\n", "coords": [["notte", [-8.758756287013144, 9.75687867581313]], ["sognare", [9.141815506360562, 8.204893687617426]]]}...]

void setup() {
    JSONArray full;
    size(1900, 1200);
    words = new HashMap<String,PVector>();
    dreams_to_coords = new HashMap<String,PVector>();
    dreams_to_words = new HashMap<String,ArrayList<String>>();
    background(0);
    full = loadJSONArray("coordinates.json");
    for (int j=0; j< full.size(); j++){
        JSONObject dream = full.getJSONObject(j);
        JSONArray values = dream.getJSONArray("coords");
        String text = dream.getString("text");
        dreams_to_words.put(text, new ArrayList<String>());
        float sum_x = 0;
        float sum_y = 0;
        for (int i = 0; i < values.size(); i++) {
            JSONArray word_xy = values.getJSONArray(i);
            String word = word_xy.getString(0);
            JSONArray xy = word_xy.getJSONArray(1);
            dreams_to_words.get(text).add(word);
            float x = xy.getFloat(0);
            float y = xy.getFloat(1);
            sum_x +=x;
            sum_y +=y;
            if (x<min_x){
                min_x=x;
            }
            if (y<min_y){
                min_y=y;
            }
            if (x>max_x){
                max_x=x;
            }
            if (y>max_y){
                max_y=y;
            }
            words.put(word, new PVector(x,y));
        }
        dreams_to_coords.put(text, new PVector(sum_x/values.size(), sum_y/values.size()));

        //        println(text.substring(0,10));
    }
    println("Total words number:"+words.size());
}

void draw() {
    background(0);
    int middle=50;
    stroke(middle);
    int y_gap=25;
    int y_increment=0;
    float lim=10;
    boolean showingdream=false;
    for (String w : words.keySet()) {
        PVector xy=words.get(w);
        float newx=map(xy.x, min_x, max_x, 0, 1900);
        float newy=map(xy.y, min_y, max_y, 0, 1200);
        point(newx, newy);
        textSize(20);
        fill(middle);
        /*        if (abs(mouseX-newx)<lim && abs(mouseY-newy)<lim){
            text(w, mouseX+y_gap, mouseY+y_increment);
            y_increment += y_gap;
        }*/
            //            text(w, newx+2, newy+20);
    }
    stroke(middle);
    fill(middle);

    for (String d : dreams_to_coords.keySet()) {
        PVector xy=dreams_to_coords.get(d);
        float newx=map(xy.x, min_x, max_x, 0, 1900);
        float newy=map(xy.y, min_y, max_y, 0, 1200);
        circle(newx, newy,10);
    }

    for (String d : dreams_to_coords.keySet()) {
        PVector xy=dreams_to_coords.get(d);
        float newx=map(xy.x, min_x, max_x, 0, 1900);
        float newy=map(xy.y, min_y, max_y, 0, 1200);        
        if (abs(mouseX-newx)<lim && abs(mouseY-newy)<lim && !showingdream){
            pushStyle();
            ArrayList<String> dreamwords=dreams_to_words.get(d);
            for (int i=0; i<dreamwords.size();i++){
                PVector wordxy=words.get(dreamwords.get(i));
                float wx=map(wordxy.x, min_x, max_x, 0, 1900);
                float wy=map(wordxy.y, min_y, max_y, 0, 1200);
                stroke(255);
                circle(wx,wy,3);
                fill(255);
                textSize(14);
                text(dreamwords.get(i), wx+4, wy);
            }
            showingdream=true;
            popStyle();
        }        

    }
    
    /*    stroke(255);
    if (mousePressed == true) {
        line(mouseX, mouseY, pmouseX, pmouseY);
   }*/
}
