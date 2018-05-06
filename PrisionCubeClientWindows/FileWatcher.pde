import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardWatchEventKinds;
import java.nio.file.WatchEvent;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;

public class FileWatcher {  

  private WatchService watcher; 
  private Path path;

  public FileWatcher(String dir) {  
    try {
      watcher = FileSystems.getDefault().newWatchService();
      path = Paths.get(dir);
      path.register(watcher, 
        StandardWatchEventKinds.ENTRY_CREATE, 
        StandardWatchEventKinds.ENTRY_DELETE, 
        StandardWatchEventKinds.ENTRY_MODIFY);
    } 
    catch (Exception e) {  
      e.printStackTrace();
    }
  }  

  public void handleEvents() {  
    try {
      while (true) {  
        WatchKey key = watcher.take();  
        for (WatchEvent<?> event : key.pollEvents()) {  
          WatchEvent.Kind kind = event.kind();  

          if (kind == StandardWatchEventKinds.OVERFLOW) { 
            continue;
          }  

          WatchEvent<Path> e = (WatchEvent<Path>)event;  
          Path fileName = e.context();  

          System.out.printf("Event %s has happened,which fileName is %s%n"  
            , kind.name(), fileName);
        }  
        if (!key.reset()) {  
          break;
        }
      }
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}  