// using System.Collections;
// using UnityEngine;
// using UnityEngine.Networking;

// public class QRCodeSender : MonoBehaviour
// {
//     private string apiUrl = "http://192.168.1.147:3060/detect_qr";  // Replace with the correct server URL
//     private GameObject lastQrObject; // Store reference to the last created cube

//     // Capture the screen and send to the Python server
//     public IEnumerator SendImageToServer(Texture2D image)
//     {
//         byte[] imageBytes = image.EncodeToPNG();

//         WWWForm form = new WWWForm();
//         form.AddBinaryData("file", imageBytes, "qr_image.png", "image/png");

//         using (UnityWebRequest www = UnityWebRequest.Post(apiUrl, form))
//         {
//             yield return www.SendWebRequest();

//             if (www.result != UnityWebRequest.Result.Success)
//             {
//                 Debug.LogError("Error sending image to server: " + www.error);
//             }
//             else
//             {
//                 Debug.Log("Response: " + www.downloadHandler.text);
//                 ProcessQRCodeResponse(www.downloadHandler.text);
//             }
//         }
//     }

//     // Parse the response
//     private void ProcessQRCodeResponse(string jsonResponse)
//     {
//         QRCodeResponse response = JsonUtility.FromJson<QRCodeResponse>(jsonResponse);

//         if (response != null && response.vertices.Length == 4)
//         {
//             Vector3[] worldVertices = new Vector3[4];
//             for (int i = 0; i < 4; i++)
//             {
//                 // Convert 2D vertices to world space
//                 worldVertices[i] = Camera.main.ScreenToWorldPoint(new Vector3(response.vertices[i].x, response.vertices[i].y, Camera.main.nearClipPlane + 0.5f)); // Add an offset to ensure the cube is fully in view
//             }

//             // Now you can calculate the normal and display your object
//             CalculateNormalAndDisplayObject(worldVertices);
//         }
//     }

//     private void CalculateNormalAndDisplayObject(Vector3[] vertices)
//     {
//         // Calculate the normal vector of the plane defined by the 4 vertices
//         Vector3 edge1 = vertices[1] - vertices[0];
//         Vector3 edge2 = vertices[2] - vertices[0];
//         Vector3 normal = Vector3.Cross(edge1, edge2).normalized;

//         // Place and rotate a 3D object at the center of the QR code
//         Vector3 center = (vertices[0] + vertices[1] + vertices[2] + vertices[3]) / 4;

//         // Calculate the size based on the distance between two vertices
//         float size = Vector3.Distance(vertices[0], vertices[1]); // Scale down the size for the cube

//         // Destroy the last QR object if it exists
//         if (lastQrObject != null)
//         {
//             Destroy(lastQrObject);
//         }

//         // Instantiate and adjust the size of the cube
//         lastQrObject = GameObject.CreatePrimitive(PrimitiveType.Cube);  // Example 3D object
//         lastQrObject.transform.position = center;

//         // Align the cube parallel to the QR code plane
//         lastQrObject.transform.up = normal; // Make the cube's up direction match the QR code surface normal

//         // Ensure the cube's forward direction aligns with the edges of the QR code
//         lastQrObject.transform.forward = Vector3.Cross(normal, edge1); 

//         // Set the size of the cube
//         lastQrObject.transform.localScale = new Vector3(size, size, size); // Make the cube a thin, flat object slightly larger than the QR code

//         // Create a white material for the cube
//         Material whiteMaterial = new Material(Shader.Find("Universal Render Pipeline/Lit"));
//         whiteMaterial.color = Color.white;
//         whiteMaterial.SetFloat("_Surface", 0); // Set to opaque surface type

//         lastQrObject.GetComponent<Renderer>().material = whiteMaterial;

//         // Start spinning the object
//         StartCoroutine(SpinObject(lastQrObject));
//     }

//     private IEnumerator SpinObject(GameObject qrObject)
//     {
//         while (true)
//         {
//             qrObject.transform.Rotate(Vector3.up, 90 * Time.deltaTime);  // Spin clockwise
//             yield return null;
//         }
//     }

//     [System.Serializable]
//     public class QRCodeResponse
//     {
//         public string objectName;
//         public QRVertex[] vertices;
//     }

//     [System.Serializable]
//     public class QRVertex
//     {
//         public float x;
//         public float y;
//     }
// }

// using System.Collections;
// using UnityEngine;
// using UnityEngine.Networking;

// public class QRCodeSender : MonoBehaviour
// {
//     private string apiUrl = "http://192.168.1.147:3060/detect_qr";
//     private GameObject lastQrObject;

//     // Public array to hold references to the model prefabs
//     public GameObject[] modelPrefabs;

//     // Capture the screen and send to the Python server
//     public IEnumerator SendImageToServer(Texture2D image)
//     {
//         byte[] imageBytes = image.EncodeToPNG();

//         WWWForm form = new WWWForm();
//         form.AddBinaryData("file", imageBytes, "qr_image.png", "image/png");

//         using (UnityWebRequest www = UnityWebRequest.Post(apiUrl, form))
//         {
//             yield return www.SendWebRequest();

//             if (www.result != UnityWebRequest.Result.Success)
//             {
//                 Debug.LogError("Error sending image to server: " + www.error);
//             }
//             else
//             {
//                 Debug.Log("Response: " + www.downloadHandler.text);
//                 ProcessQRCodeResponse(www.downloadHandler.text);
//             }
//         }
//     }

//     private void ProcessQRCodeResponse(string jsonResponse)
//     {
//         Debug.Log("Received JSON response: " + jsonResponse);

//         try
//         {
//             QRCodeResponse response = JsonUtility.FromJson<QRCodeResponse>(jsonResponse);

//             if (response != null && response.vertices.Length == 4)
//             {
//                 Debug.Log("Response objectName field: " + response.objectName);

//                 string objectName = response.objectName;

//                 Debug.Log("Extracted object name: " + objectName);

//                 Vector3[] worldVertices = new Vector3[4];
//                 for (int i = 0; i < 4; i++)
//                 {
//                     // Convert 2D vertices to world space
//                     worldVertices[i] = Camera.main.ScreenToWorldPoint(new Vector3(response.vertices[i].x, response.vertices[i].y, Camera.main.nearClipPlane + 0.5f));
//                 }

//                 // Now you can calculate the normal and display your object
//                 CalculateNormalAndDisplayObject(worldVertices, objectName);
//             }
//             else
//             {
//                 Debug.LogWarning("Invalid QR code response or vertices");
//             }
//         }
//         catch (System.Exception e)
//         {
//             Debug.LogError("Exception in ProcessQRCodeResponse: " + e.Message);
//         }
//     }

//     private void CalculateNormalAndDisplayObject(Vector3[] vertices, string objectName)
//     {
//         // Calculate the normal vector of the plane defined by the 4 vertices
//         Vector3 edge1 = vertices[1] - vertices[0];
//         Vector3 edge2 = vertices[2] - vertices[0];
//         Vector3 normal = Vector3.Cross(edge1, edge2).normalized;

//         // Place and rotate a 3D object at the center of the QR code
//         Vector3 center = (vertices[0] + vertices[1] + vertices[2] + vertices[3]) / 4;

//         // // Calculate the size based on the distance between two vertices
//         // float size = Vector3.Distance(vertices[0], vertices[1]); // Scale down the size for the cube

//         // Destroy the last QR object if it exists
//         if (lastQrObject != null)
//         {
//             Destroy(lastQrObject);
//         }

//         // Find the matching model prefab
//         GameObject modelPrefab = FindModelPrefab(objectName);

//         if (modelPrefab != null)
//         {
//             // Instantiate the model
//             lastQrObject = Instantiate(modelPrefab, center, Quaternion.LookRotation(normal));
//             // // Adjust the scale if necessary
//             // lastQrObject.transform.localScale = new Vector3(size * 0.1f, size * 0.1f, size * 0.1f);

//             // Preserve the original scale of the prefab
//             lastQrObject.transform.localScale = modelPrefab.transform.localScale;

//             // Start spinning the object (optional)
//             StartCoroutine(SpinObject(lastQrObject));
//         }
//         else
//         {
//             Debug.LogWarning("No matching model found for object name: " + objectName);
//         }
//     }

//     private GameObject FindModelPrefab(string objectName)
//     {
//         Debug.Log("Looking for a model with the name: " + objectName);

//         // Loop through the modelPrefabs array to find a match
//         foreach (GameObject prefab in modelPrefabs)
//         {
//             Debug.Log("Checking prefab: " + prefab.name);

//             if (prefab.name.Equals(objectName, System.StringComparison.OrdinalIgnoreCase))
//             {
//                 Debug.Log("Match found for: " + objectName);
//                 return prefab; // Return the matching prefab
//             }
//         }

//         Debug.LogWarning("No matching prefab found for object name: " + objectName);
//         return null; // Return null if no match found
//     }

//     private IEnumerator SpinObject(GameObject qrObject)
//     {
//         while (true)
//         {
//             qrObject.transform.Rotate(Vector3.up, 90 * Time.deltaTime);
//             yield return null;
//         }
//     }

//     [System.Serializable]
//     public class QRCodeResponse
//     {
//         public string objectName;
//         public QRVertex[] vertices;
//     }

//     [System.Serializable]
//     public class QRVertex
//     {
//         public float x;
//         public float y;
//     }
// }

using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

public class QRCodeSender : MonoBehaviour
{
    private string apiUrl = "http://192.168.1.147:3060/detect_qr";
    private GameObject lastQrObject;

    // Public arrays to hold references to the model, video, and book page prefabs
    public GameObject[] modelPrefabs;
    public GameObject[] videoPrefabs;
    public GameObject[] bookPrefabs;

    // Hardcoded mode selection (true for object mode, false for video mode, and book mode for images)
    private bool isObjectMode = false;
    private bool isVideoMode = false;
    private bool isBookMode = true;

    // Capture the screen and send to the Python server
    public IEnumerator SendImageToServer(Texture2D image)
    {
        byte[] imageBytes = image.EncodeToPNG();

        WWWForm form = new WWWForm();
        form.AddBinaryData("file", imageBytes, "qr_image.png", "image/png");

        using (UnityWebRequest www = UnityWebRequest.Post(apiUrl, form))
        {
            yield return www.SendWebRequest();

            if (www.result != UnityWebRequest.Result.Success)
            {
                Debug.LogError("Error sending image to server: " + www.error);
            }
            else
            {
                Debug.Log("Response: " + www.downloadHandler.text);
                ProcessQRCodeResponse(www.downloadHandler.text);
            }
        }
    }

    private void ProcessQRCodeResponse(string jsonResponse)
    {
        Debug.Log("Received JSON response: " + jsonResponse);

        try
        {
            QRCodeResponse response = JsonUtility.FromJson<QRCodeResponse>(jsonResponse);

            if (response != null && response.vertices.Length == 4)
            {
                Debug.Log("Response objectName field: " + response.objectName);

                string objectName = response.objectName;

                Debug.Log("Extracted object name: " + objectName);

                Vector3[] worldVertices = new Vector3[4];
                for (int i = 0; i < 4; i++)
                {
                    // Convert 2D vertices to world space
                    worldVertices[i] = Camera.main.ScreenToWorldPoint(new Vector3(response.vertices[i].x, response.vertices[i].y, Camera.main.nearClipPlane + 0.5f));
                }

                // Now you can calculate the normal and display your object, video, or book image
                CalculateNormalAndDisplay(worldVertices, objectName);
            }
            else
            {
                Debug.LogWarning("Invalid QR code response or vertices");
            }
        }
        catch (System.Exception e)
        {
            Debug.LogError("Exception in ProcessQRCodeResponse: " + e.Message);
        }
    }

    private void CalculateNormalAndDisplay(Vector3[] vertices, string objectName)
    {
        // Calculate the normal vector of the plane defined by the 4 vertices
        Vector3 edge1 = vertices[1] - vertices[0];
        Vector3 edge2 = vertices[2] - vertices[0];
        Vector3 normal = Vector3.Cross(edge1, edge2).normalized;

        // Place and rotate the object/video/book page at the center of the QR code
        Vector3 center = (vertices[0] + vertices[1] + vertices[2] + vertices[3]) / 4;

        // Destroy the last QR object if it exists
        if (lastQrObject != null)
        {
            Destroy(lastQrObject);
        }

        if (isObjectMode)
        {
            // Instantiate a 3D object
            GameObject modelPrefab = FindModelPrefab(objectName);
            if (modelPrefab != null)
            {
                lastQrObject = Instantiate(modelPrefab, center, Quaternion.LookRotation(normal));

                // Preserve the original scale of the prefab
                lastQrObject.transform.localScale = modelPrefab.transform.localScale;

                // Start spinning the object (optional)
                StartCoroutine(SpinObject(lastQrObject));
            }
            else
            {
                Debug.LogWarning("No matching model found for object name: " + objectName);
            }
        }
        else if (isVideoMode)
        {
            // Instantiate a video object
            GameObject videoPrefab = FindVideoPrefab(objectName);
            if (videoPrefab != null)
            {
                lastQrObject = Instantiate(videoPrefab, center, Quaternion.LookRotation(normal));

                // Preserve the original scale of the video prefab
                lastQrObject.transform.localScale = videoPrefab.transform.localScale;

                // Start playing the video (assuming the video prefab contains a video player component)
                var videoPlayer = lastQrObject.GetComponent<UnityEngine.Video.VideoPlayer>();
                if (videoPlayer != null)
                {
                    videoPlayer.Play();
                }
            }
            else
            {
                Debug.LogWarning("No matching video found for object name: " + objectName);
            }
        }
        else if (isBookMode)
        {
            // Instantiate a book page image
            GameObject bookPrefab = FindBookPrefab(objectName);
            if (bookPrefab != null)
            {
                lastQrObject = Instantiate(bookPrefab, center, Quaternion.LookRotation(normal));

                // Preserve the original scale of the book page prefab
                lastQrObject.transform.localScale = bookPrefab.transform.localScale;
            }
            else
            {
                Debug.LogWarning("No matching book page found for object name: " + objectName);
            }
        }
    }

    private GameObject FindModelPrefab(string objectName)
    {
        Debug.Log("Looking for a model with the name: " + objectName);

        // Loop through the modelPrefabs array to find a match
        foreach (GameObject prefab in modelPrefabs)
        {
            if (prefab.name.Equals(objectName, System.StringComparison.OrdinalIgnoreCase))
            {
                return prefab; // Return the matching prefab
            }
        }

        Debug.LogWarning("No matching prefab found for object name: " + objectName);
        return null; // Return null if no match found
    }

    private GameObject FindVideoPrefab(string objectName)
    {
        Debug.Log("Looking for a video prefab with the name: " + objectName + "_video");

        // Loop through the videoPrefabs array to find a match
        foreach (GameObject prefab in videoPrefabs)
        {
            if (prefab.name.Equals(objectName + "_video", System.StringComparison.OrdinalIgnoreCase))
            {
                return prefab; // Return the matching video prefab
            }
        }

        Debug.LogWarning("No matching video prefab found for object name: " + objectName);
        return null; // Return null if no match found
    }

    private GameObject FindBookPrefab(string objectName)
    {
        Debug.Log("Looking for a book page prefab with the name: " + objectName + "_book");

        // Loop through the bookPrefabs array to find a match
        foreach (GameObject prefab in bookPrefabs)
        {
            if (prefab.name.Equals(objectName + "_book", System.StringComparison.OrdinalIgnoreCase))
            {
                return prefab; // Return the matching book prefab
            }
        }

        Debug.LogWarning("No matching book page prefab found for object name: " + objectName);
        return null; // Return null if no match found
    }

    private IEnumerator SpinObject(GameObject qrObject)
    {
        while (true)
        {
            qrObject.transform.Rotate(Vector3.up, 90 * Time.deltaTime);
            yield return null;
        }
    }

    [System.Serializable]
    public class QRCodeResponse
    {
        public string objectName;
        public QRVertex[] vertices;
    }

    [System.Serializable]
    public class QRVertex
    {
        public float x;
        public float y;
    }
}
