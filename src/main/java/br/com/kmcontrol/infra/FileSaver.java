package br.com.kmcontrol.infra;

import java.io.File;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import br.com.kmcontrol.entity.Atendimento;

@Component
public class FileSaver {

    @Autowired
    HttpServletRequest request;

    public String write(String basePath, MultipartFile file, Atendimento atendimento) {
    	String dataFormatada = new SimpleDateFormat("ddMMyyyy").format(atendimento.getDataAtendimento().getTime());
        try {
            String realPath = System.getenv("OPENSHIFT_DATA_DIR") + basePath;
            File dir = new File(realPath);
            if (!dir.exists()){
            	dir.mkdirs();            	
            }
            System.out.println(realPath);
            String fileName = "RAT" + atendimento.getNumeroChamado() + dataFormatada + file.getOriginalFilename().substring(Math.max(0, file.getOriginalFilename().length() - 4));
            String path = realPath + "/" + fileName;
            file.transferTo(new File(path));
            return basePath + "/" + fileName;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    
    public boolean delete(String filePath){
    	String realPath = System.getenv("OPENSHIFT_DATA_DIR");
    	File file = new File(realPath + "/" + filePath);
    	if(file.delete()){
    		return true;
    	}  	
    	return false;
    }
}
