import os

file_path = 'snipplets/grid/item.tpl'
with open(file_path, 'r') as f:
    lines = f.readlines()

new_lines = []
skip = False
for i, line in enumerate(lines):
    # Match the start of the form in the overlay block (lines 135-140 approx)
    if '<form class="js-product-form" method="post" action="{{ store.cart_url }}">' in line and i > 120 and i < 150:
        indent = line[:line.find('<form')]
        new_lines.append(f'{indent}<div class="js-item-submit-container item-submit-container position-relative">\n')
        new_lines.append(f'{indent}    {{% if product.variations and settings.quick_shop %}}\n')
        new_lines.append(f'{indent}        <div data-toggle="#quickshop-modal" data-modal-url="modal-fullscreen-quickshop" class="js-quickshop-modal-open js-fullscreen-modal-open js-modal-open btn-overlay-buy text-center pointer" title="{{{{ \'Compra rápida de\' | translate }}}} {{{{ product.name }}}}" aria-label="{{{{ \'Compra rápida de\' | translate }}}} {{{{ product.name }}}}" data-component="product-list-item.add-to-cart" data-component-value="{{{{product.id}}}}">\n')
        new_lines.append(f'{indent}            {{{{ \'Add to cart\' | translate }}}}\n')
        new_lines.append(f'{indent}        </div>\n')
        new_lines.append(f'{indent}    {{% else %}}\n')
        new_lines.append(f'{indent}        <form class="js-product-form" method="post" action="{{{{ store.cart_url }}}}">\n')
        new_lines.append(f'{indent}            <input type="hidden" name="add_to_cart" value="{{{{product.id}}}}" />\n')
        new_lines.append(f'{indent}            <input type="submit" class="js-addtocart js-prod-submit-form btn-overlay-buy" value="{{{{ \'Add to cart\' | translate }}}}" data-component="product-list-item.add-to-cart" data-component-value="{{{{ product.id }}}}"/>\n')
        new_lines.append(f'{indent}        </form>\n')
        new_lines.append(f'{indent}    {{% endif %}}\n')
        new_lines.append(f'{indent}</div>\n')
        skip = True
    elif '</form>' in line and skip:
        skip = False
        continue
    elif skip:
        continue
    else:
        new_lines.append(line)

with open(file_path, 'w') as f:
    f.writelines(new_lines)
print("Patch applied successfully")
