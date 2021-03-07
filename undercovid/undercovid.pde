import java.util.Map;
HashMap<String,PVector> words;
HashMap<String,ArrayList<String>> dreams_to_words;
HashMap<String,PVector> dreams_to_coords;

float min_x=0;
float min_y=0;
float max_x=0;
float max_y=0;
boolean keepinfo=true;
boolean show_dream_text = true;
int dreamtext_max_width = 151;

// sample line
// [{"text": "praticamente questa notte\n", "coords": [["notte", [-8.758756287013144, 9.75687867581313]], ["sognare", [9.141815506360562, 8.204893687617426]]]}...]
float w=1000;
float h=700;
void setup() {
    JSONArray full;
    size(900, 700);
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

void mousePressed(){
    keepinfo=!keepinfo;
    if (keepinfo) loop();
    if (!keepinfo) noLoop();
}

String lastprint="";

void draw() {
    background(0);
    int middle=50;
    stroke(middle);
    int y_gap=25;
    int y_increment=0;
    float lim=10;
    boolean showingdream=false;

    if (keyPressed) {
        if (key == 's' && dreamtext_max_width>20) {
            dreamtext_max_width-=10;
        }
        if (key == 'h') {
            dreamtext_max_width+=10;
        }
        
    }
    
    /* here we draw the words */
    for (String word : words.keySet()) {
        PVector xy=words.get(word);
        float newx=map(xy.x, min_x, max_x, 0, w);
        float newy=map(xy.y, min_y, max_y, 0, h);
        point(newx, newy);
        textSize(20);
        fill(middle);
    }
    stroke(middle);
    fill(middle);

    /* here we draw the dreams */
    for (String d : dreams_to_coords.keySet()) {
        PVector xy=dreams_to_coords.get(d);
        float newx=map(xy.x, min_x, max_x, 0, w);
        float newy=map(xy.y, min_y, max_y, 0, h);
        circle(newx, newy, 10);
    }

    /* here we check if more details have to be drawn */
    for (String d : dreams_to_coords.keySet()) {
        PVector xy=dreams_to_coords.get(d);
        float newx=map(xy.x, min_x, max_x, 0, w);
        float newy=map(xy.y, min_y, max_y, 0, h);
        String wordslist="";
        
        if (abs(mouseX-newx)<lim && abs(mouseY-newy)<lim && !showingdream) {
            pushStyle();
            ArrayList<String> dreamwords=dreams_to_words.get(d);
            for (int i=0; i<dreamwords.size();i++){
                PVector wordxy=words.get(dreamwords.get(i));
                wordslist+=" "+dreamwords.get(i);
                float wx=map(wordxy.x, min_x, max_x, 0, w);
                float wy=map(wordxy.y, min_y, max_y, 0, h);
                stroke(255);
                circle(wx,wy,3);
                fill(255);
                textSize(14);
            }

            showingdream=true;
            if (lastprint!=d){
                println("\n"+d);
                lastprint=d;
            }

            if (show_dream_text) {
                int lineh=14;                
                textSize(lineh);
                int basewidth=10;
                int len=wordslist.length();
                fill(180);
                for (int i=0; i<len/dreamtext_max_width+1;i++){
                    String sub=wordslist.substring(Math.min(len,dreamtext_max_width*i), Math.min(len, dreamtext_max_width*(i+1)));
                    text(sub, 0, basewidth+(lineh+2)*i);
                }
                popStyle();
            }
        }        

    }
    
}
