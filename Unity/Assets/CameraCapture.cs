using UnityEngine;
using System.Collections;
public class CameraCapture : MonoBehaviour
{
    public Camera arCamera;
    public QRCodeSender qrCodeSender;

    void Start()
    {
        StartCoroutine(CaptureAndSendImage());
    }

    IEnumerator CaptureAndSendImage()
    {
        while (true)
        {
            yield return new WaitForSeconds(2);  // Send image every 2 seconds

            // Capture the camera's current view
            RenderTexture rt = new RenderTexture(Screen.width, Screen.height, 24);
            arCamera.targetTexture = rt;
            Texture2D screenImage = new Texture2D(Screen.width, Screen.height, TextureFormat.RGB24, false);
            arCamera.Render();
            RenderTexture.active = rt;
            screenImage.ReadPixels(new Rect(0, 0, Screen.width, Screen.height), 0, 0);
            screenImage.Apply();
            arCamera.targetTexture = null;

            // Send image to the Python server
            StartCoroutine(qrCodeSender.SendImageToServer(screenImage));
        }
    }
}
