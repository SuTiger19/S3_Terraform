document.addEventListener('DOMContentLoaded', function() {
    const uploadForm = document.getElementById('uploadForm');
    const statusMessage = document.getElementById('statusMessage');
    const fileInput = document.getElementById('document');

    AWS.config.update({
        accessKeyId:"PUT UR ACESS KEY", secretAccessKey: 'PUT UR SECERT ACESSKEY',
       // accessKeyId = "" ,
       // secretAccessKey = ""

        sessionToken: "IQoJb3JpZ2luX2VjEKH//////////wEaCXVzLXdlc3QtMiJIMEYCIQCJ/28/x9Fi84TDJdZ7NEzuXb7BuiGWcdWXWNY1Ik3ehgIhAKKKDuLXkmldJXzoy3K7gKDw03XJ2YJ6ZMrgoLLWG/E4Kq8CCEoQABoMNjM3NDIzMjMwNTYyIgx5/Y4daMgG6fmv/cQqjAJrkDRPOc0iYjfnZJ26CDOJv6Smq04Kd7dqxdJFgXrMWxWEC0sMyrNr/d/qM4u0Qpe6wiPtBUeuHw7iTCbUtnTYyMLfUk5EZvzDVWlL8hagf5kjAtzZMzQiC93zLrCGV3kVn7RppjbtiM6+awk/im5AHBnSvmJi0xqcjvmTv0ASz/kLsitYc8zATxg3PNtWbJUaSsSDRAR8FgWbYgg73kN0lCaFWdMIGnXITliM6aohhwV+sGwPT0ujOW+HVlMofLsn+9ojwxNkiijmx844BNx5Cxfv64XIhpMVGJJThbsOeTCZwINTjPCvFHy+IkhxrlfxsKPA3FyxQjHPRc8LqtzkItvJ2Qzdo61XyR1kMNn86MAGOpwBIBD5mOs66Pb8VxR1J6IPJ6zLX4UdcWsHJcbZ9dFO99ZL15J4FlQSDaowY4ttJ3gq/HzjxAYrINMpM5V25PFkvSM32PiAk/YWtEE4lSIZUersBVG5vBs4lWtga1FkSGHcaw+gInBQmUXd6c2EcjzWZ2DjhGw7q3kgkW8BIj+9+YvX47qgrKFJXjmCa7CzZ45NUQk+PiXyOsVzS0GC",
        region: 'us-east-1'
    });

    const bucketName = 'terraform-sudeep-2025-sudeepsaurabh-webp-1';

    
    const s3 =  new AWS.S3({
        apiVersion: "2006-03-01",
        params: { Bucket: bucketName },
      });


    
    // File validation
    fileInput.addEventListener('change', function() {
        validateFile(this.files[0]);
    });
    
    // Form submission
    uploadForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const file = fileInput.files[0];
        if (!validateFile(file)) return;
        
        uploadDocument(
            file,
            document.getElementById('clientId').value,
            document.getElementById('caseId').value,
            document.getElementById('documentType').value
        );
    });
    
    function validateFile(file) {
        if (!file) {
            showStatus('Please select a file to upload.', 'error');
            return false;
        }
        
        // Check file size (2MB max)
        if (file.size > 2 * 1024 * 1024) {
            showStatus('File size exceeds the 2MB limit.', 'error');
            return false;
        }
        
        // Check file extension
        const fileName = file.name;
        const extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        const allowedExtensions = ['doc', 'txt', 'pdf', 'ppt'];
        
        if (!allowedExtensions.includes(extension)) {
            showStatus('Only .doc, .txt, .pdf, and .ppt files are allowed.', 'error');
            return false;
        }
        
        return true;
    }
    
    function uploadDocument(file, clientId, caseId, documentType) {
    

        // Construct object key
        const fileKey = `uploads/${clientId}/${caseId}/${documentType}/${file.name}`;

        // Show loading status
        showStatus('Uploading your document...', 'loading');

        // Prepare S3 upload params
        const params = {
            Bucket: bucketName,
            Key: fileKey,
            Body: file,
            ContentType: file.type
        };

        // Upload to S3
        s3.upload(params, function (err, data) {
            if (err) {
                console.error('Upload error:', err);
                showStatus('Error uploading document. Please try again.', 'error');
            } else {
                console.log('Upload success:', data.Location);
                showStatus('Document uploaded successfully!', 'success');
                uploadForm.reset();
            }
        });
    }

    
    function showStatus(message, type) {
        statusMessage.textContent = message;
        statusMessage.className = 'status-message';
        statusMessage.classList.add(type);
    }
}); 