import qrcode

def create_qr_code(data, file_name):
    # Create QR code with embedded data (e.g., object name)
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(data)
    qr.make(fit=True)

    # Save the QR code as an image file
    img = qr.make_image(fill='black', back_color='white')
    img.save(f"{file_name}.png")


# Example: Create QR codes for different objects
create_qr_code('{"object": "cat"}', 'cat_qr')
create_qr_code('{"object": "dog"}', 'dog_qr')
create_qr_code('{"object": "cube"}', 'cube_qr')
create_qr_code('{"object": "The Tortoise and the Hare_0"}', 'book0')
create_qr_code('{"object": "The Tortoise and the Hare_1"}', 'book1')
create_qr_code('{"object": "The Tortoise and the Hare_2"}', 'book2')
create_qr_code('{"object": "The Tortoise and the Hare_3"}', 'book3')
