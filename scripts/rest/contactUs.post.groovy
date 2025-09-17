import org.springframework.http.*
import org.springframework.web.client.RestTemplate
import groovy.json.JsonOutput

println "Processing Contact Us Request with values:"
println params

def restTemplate = new org.springframework.web.client.RestTemplate()
def url = "https://cms-authoring.vnsolutions-io.com/studio/api/2/submit-form"
def headers = new org.springframework.http.HttpHeaders()
headers.setContentType(MediaType.TEXT_PLAIN)
headers.set("X-Requested-With", "XMLHttpRequest")

// Dữ liệu gửi vào body dưới dạng chuỗi JSON
def body = String.valueOf(params)// ví dụ bạn muốn gửi JSON

def entity = new HttpEntity<>(body, headers)

def response = restTemplate.exchange(
    url,
    org.springframework.http.HttpMethod.POST,
    entity,
    Void.class
)